//
//
//  CardListPresenter.swift
//
//  Copyright (c) 2021 Tinkoff Bank
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import TinkoffASDKCore
import UIKit

final class CardListPresenter {
    // MARK: Internal Types

    private enum ScreenState {
        case initial
        case showingCards
        case editingCards
        case showingStub
    }

    // MARK: Dependencies

    weak var view: ICardListViewInput?
    private weak var output: ICardListPresenterOutput?
    private let screen: SdkScreen
    private let imageResolver: IPaymentSystemImageResolver
    private let bankResolver: IBankResolver
    private let paymentSystemResolver: IPaymentSystemResolver
    private var screenConfiguration: CardListScreenConfiguration
    private let cardsController: ICardsController
    private let router: ICardListRouter
    private let errorHandler: IErrorHandler
    private var moduleCompletion: VoidBlock?

    // MARK: State

    private var sections: [CardListSection] { getSections() }
    private var isLoading = false
    private var screenState = ScreenState.initial
    private var deactivateCardResult: Result<RemoveCardPayload, Error>?
    private var cards: [PaymentCard] {
        didSet {
            guard cards != oldValue else { return }
            output?.cardList(didUpdate: cards)
        }
    }

    // MARK: Init

    init(
        screenConfiguration: CardListScreenConfiguration,
        cardsController: ICardsController,
        router: ICardListRouter,
        imageResolver: IPaymentSystemImageResolver,
        bankResolver: IBankResolver,
        paymentSystemResolver: IPaymentSystemResolver,
        errorHandler: IErrorHandler,
        cards: [PaymentCard] = [],
        output: ICardListPresenterOutput? = nil,
        moduleCompletion: VoidBlock?
    ) {
        self.screenConfiguration = screenConfiguration
        self.imageResolver = imageResolver
        self.bankResolver = bankResolver
        self.paymentSystemResolver = paymentSystemResolver
        self.errorHandler = errorHandler
        self.cardsController = cardsController
        self.router = router
        self.cards = cards
        self.output = output
        self.moduleCompletion = moduleCompletion

        switch screenConfiguration.useCase {
        case .cardList: screen = .cardList
        case .cardPaymentList: screen = .cardPayment
        }
    }

    // MARK: Helpers

    private func transform(_ paymentCards: [PaymentCard]) -> [CardList.Card] {
        paymentCards.map { card in
            let bank = bankResolver.resolve(cardNumber: card.pan).getBank()
            let cardModel = DynamicIconCardView.Model(
                data: DynamicIconCardView.Data(
                    bank: bank?.icon,
                    paymentSystem: paymentSystemResolver
                        .resolve(by: card.pan).getPaymentSystem()?.icon
                ), style: DynamicIconCardView.Style(enableAnimations: false)
            )

            let bankText = bank?.naming ?? ""
            var cardNumberText = String.format(pan: card.pan)
            cardNumberText = bankText.isEmpty ? cardNumberText : (" " + cardNumberText)

            return CardList.Card(
                id: card.cardId,
                pan: .format(pan: card.pan),
                cardModel: cardModel,
                bankNameText: bankText,
                cardNumberText: cardNumberText,
                isInEditingMode: screenState == .editingCards,
                hasCheckmarkInNormalMode: screenConfiguration.selectedCardId == card.cardId
            )
        }
    }
}

// MARK: - ICardListViewOutput

extension CardListPresenter: ICardListViewOutput {

    func viewDidLoad() {
        view?.showShimmer()
        fetchCardsIfNeeded()
    }

    func viewDidTapCard(cardIndex: Int) {
        guard screenConfiguration.useCase == .cardPaymentList else { return }

        let selectedCard = cards[cardIndex]
        output?.cardList(willCloseAfterSelecting: selectedCard)
        view?.closeScreen()
    }

    func viewDidTapCloseButton() {
        router.closeScreen(completion: moduleCompletion)
    }

    func viewDidTapAddCardCell() {
        switch screenConfiguration.useCase {
        case .cardList:
            router.openAddNewCard(customerKey: cardsController.customerKey, output: self)
        case .cardPaymentList:
            router.openCardPayment()
        }
    }

    func viewDidHideShimmer(fetchCardsResult: Result<[PaymentCard], Error>) {
        handleFetchedActiveCard(result: fetchCardsResult)
    }

    func viewDidShowAddedCardSnackbar() {
        reloadCollection()
    }

    func view(didTapDeleteOn card: CardList.Card) {
        isLoading = true
        view?.disableViewUserInteraction()
        let removingCardText = Loc.Acquiring.CardList.deleteSnackBar(String.formatShort(pan: card.pan))
        view?.showRemovingCardSnackBar(text: removingCardText)

        cardsController.removeCard(cardId: card.id) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.deactivateCardResult = result
            self.view?.hideLoadingSnackbar()
        }
    }

    func viewDidTapEditButton() {
        guard screenState == .showingCards, !isLoading else { return }
        screenState = .editingCards
        view?.showDoneEditingButton()
        reloadCollection()
    }

    func viewDidTapDoneEditingButton() {
        guard !isLoading else { return }
        screenState = .showingCards
        view?.showEditButton()
        reloadCollection()
    }

    func viewDidHideRemovingCardSnackBar() {
        if let result = deactivateCardResult {
            deactivateCardResult = nil

            switch result {
            case let .success(payload):
                cards.removeAll { $0.cardId == payload.cardId }
                if screenConfiguration.useCase == .cardPaymentList, let newSelectedCardId = cards.first?.cardId {
                    screenConfiguration.selectedCardId = newSelectedCardId
                }
                handleFetchedActiveCard(result: .success(cards))
            case let .failure(error):
                view?.enableViewUserInteraction()
                let result = errorHandler.handle(error: error, screen: screen, event: .removeCard)
                handle(errorHandlingResult: result)
            }
        }
    }
}

// MARK: - IAddNewCardPresenterOutput

extension CardListPresenter: IAddNewCardPresenterOutput {
    func addNewCardDidReceive(result: AddCardResult) {
        switch result {
        case .cancelled, .failed:
            break
        case let .succeded(card):
            screenState = .showingCards
            cards.append(card)
            view?.showAddedCardSnackbar(cardMaskedPan: String.formatShort(pan: card.pan))
        }
    }
}

extension CardListPresenter {

    // MARK: - Private

    private func fetchCardsIfNeeded() {
        guard cards.isEmpty else {
            view?.hideShimmer(fetchCardsResult: .success(cards))
            return
        }

        isLoading = true

        cardsController.getActiveCards { [weak self] result in
            self?.isLoading = false
            self?.view?.hideShimmer(fetchCardsResult: result)
        }
    }

    private func handleFetchedActiveCard(result: Result<[PaymentCard], Error>) {
        isLoading = false

        switch result {
        case let .success(paymentCards):
            cards = paymentCards
            if paymentCards.isEmpty {
                viewDidTapDoneEditingButton()
                reloadCollection()
                let visualError: VisualErrorStub = screen == .cardList ? .noCardsInCardList : .noCardsInCardPaymentList
                handle(errorHandlingResult: .show(visualError, .insideContainer))
            } else {
                if screenState != .editingCards {
                    screenState = .showingCards
                }
                reloadCollection()
            }

        case let .failure(error):
            let result = errorHandler.handle(
                error: error,
                screen: screen,
                event: cards.isEmpty ? .inititialization : .payment
            )
            handle(errorHandlingResult: result)
        }

        view?.enableViewUserInteraction()
    }

    private func reloadCollection() {
        showBarButton()
        view?.hideStub()
        view?.reload(sections: sections)
    }

    private func showBarButton() {
        screenState == .editingCards
            ? view?.showDoneEditingButton()
            : view?.showEditButton()
    }

    private func getSections() -> [CardListSection] {
        var result: [CardListSection] = [
            .cards(data: transform(cards)),
        ]

        if screenState != .editingCards {
            result.append(.addCard(data: prepareAddCardConfigs()))
        }
        return result
    }

    private func prepareAddCardConfigs() -> [(ImageAsset, String)] {
        return [
            (icon: Asset.Icons.cardPlus, title: screenConfiguration.newCardTitle),
        ]
    }

    private func handle(errorHandlingResult: ErrorHandlingResult) {
        switch errorHandlingResult {
        case let .show(stub, .insideContainer):
            let stubData = stub.convertToFullStubMode { [weak self] in
                switch stub {
                case .noCardsInCardList, .noCardsInCardPaymentList:
                    self?.viewDidTapAddCardCell()
                case .notLoaded:
                    self?.view?.hideStub()
                    self?.viewDidLoad()
                case .weHaveProblem:
                    self?.view?.closeScreen()
                default:
                    assertionFailure()
                }
            }
            view?.hideRightBarButton()
            view?.showFullStub(data: stubData)
        case .showToast(.failedToRemoveCard):
            view?.showProblemSnackBar(text: Loc.CommonAlert.DeleteCard.title)
        default:
            assertionFailure()
        }
    }
}

// MARK: - String + Helpers

extension String {
    static func format(pan: String) -> String {
        "• " + pan.suffix(4)
    }

    static func formatShort(pan: String) -> String {
        "•" + pan.suffix(4)
    }
}
