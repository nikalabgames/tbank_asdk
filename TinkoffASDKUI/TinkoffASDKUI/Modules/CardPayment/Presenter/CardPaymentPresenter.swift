//
//  CardPaymentPresenter.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 20.01.2023.
//

import Foundation
import TinkoffASDKCore

final class CardPaymentPresenter: ICardPaymentViewControllerOutput {

    // MARK: Dependencies

    weak var view: ICardPaymentViewControllerInput?
    private let router: ICardPaymentRouter
    private let savedCardViewPresenterAssembly: ISavedCardViewPresenterAssembly
    private let cardFieldPresenterAssembly: ICardFieldPresenterAssembly
    private let switchViewPresenterAssembly: ISwitchViewPresenterAssembly
    private let emailViewPresenterAssembly: IEmailViewPresenterAssembly
    private let payButtonViewPresenterAssembly: IPayButtonViewPresenterAssembly
    private weak var output: ICardPaymentPresenterModuleOutput?
    private weak var cardListOutput: ICardListPresenterOutput?

    private let cardsController: ICardsController?
    private let paymentController: IPaymentController

    private let mainDispatchQueue: IDispatchQueue

    // MARK: Properties

    private var cellTypes = [CardPaymentCellType]()
    private var savedCardPresenter: ISavedCardViewOutput?
    private lazy var cardFieldPresenter = createCardFieldViewPresenter()
    private lazy var receiptSwitchViewPresenter = createReceiptSwitchViewPresenter()
    private lazy var emailPresenter = createEmailViewPresenter()
    private lazy var payButtonPresenter = createPayButtonViewPresenter()

    private var isCardFieldValid = false
    private var isBlockingViewInteraction = false

    private var initialActiveCards: [PaymentCard]? {
        didSet {
            guard initialActiveCards != oldValue, let cards = initialActiveCards else { return }
            cardListOutput?.cardList(didUpdate: cards)
        }
    }

    private var activeCards: [PaymentCard] { initialActiveCards ?? [] }
    private let paymentFlow: PaymentFlow
    private let amount: Int64
    private let customerEmail: String

    private let isCardFieldScanButtonNeeded: Bool

    // MARK: Initialization

    init(
        router: ICardPaymentRouter,
        output: ICardPaymentPresenterModuleOutput?,
        savedCardViewPresenterAssembly: ISavedCardViewPresenterAssembly,
        cardFieldPresenterAssembly: ICardFieldPresenterAssembly,
        switchViewPresenterAssembly: ISwitchViewPresenterAssembly,
        emailViewPresenterAssembly: IEmailViewPresenterAssembly,
        payButtonViewPresenterAssembly: IPayButtonViewPresenterAssembly,
        cardListOutput: ICardListPresenterOutput?,
        cardsController: ICardsController?,
        paymentController: IPaymentController,
        mainDispatchQueue: IDispatchQueue,
        activeCards: [PaymentCard]?,
        paymentFlow: PaymentFlow,
        amount: Int64,
        isCardFieldScanButtonNeeded: Bool
    ) {
        self.router = router
        self.output = output
        self.savedCardViewPresenterAssembly = savedCardViewPresenterAssembly
        self.cardFieldPresenterAssembly = cardFieldPresenterAssembly
        self.switchViewPresenterAssembly = switchViewPresenterAssembly
        self.emailViewPresenterAssembly = emailViewPresenterAssembly
        self.payButtonViewPresenterAssembly = payButtonViewPresenterAssembly
        self.cardListOutput = cardListOutput
        self.cardsController = cardsController
        self.paymentController = paymentController
        self.mainDispatchQueue = mainDispatchQueue
        initialActiveCards = activeCards
        self.paymentFlow = paymentFlow
        self.amount = amount
        customerEmail = paymentFlow.customerOptions?.email ?? ""
        self.isCardFieldScanButtonNeeded = isCardFieldScanButtonNeeded
    }
}

// MARK: - ICardPaymentViewControllerOutput

extension CardPaymentPresenter {
    func viewDidLoad() {
        if initialActiveCards != nil {
            setupInitialStateScreen()
        } else {
            view?.showActivityIndicator(with: .xlYellow)
            loadCards()
        }
    }

    func viewDidAppear() {
        guard !isBlockingViewInteraction else { return }
        if activeCards.isEmpty {
            cardFieldPresenter.activate(textFieldType: .cardNumber)
        } else {
            savedCardPresenter?.activateCVCField()
        }
    }

    func closeButtonPressed() {
        router.closeScreen()
    }

    func numberOfRows() -> Int {
        cellTypes.count
    }

    func cellType(for row: Int) -> CardPaymentCellType {
        cellTypes[row]
    }
}

// MARK: - ICardFieldOutput

extension CardPaymentPresenter: ICardFieldOutput {
    func scanButtonPressed() {
        router.showCardScanner { [weak self] cardNumber, expiration, cvc in
            self?.cardFieldPresenter.set(textFieldType: .cardNumber, text: cardNumber)
            self?.cardFieldPresenter.set(textFieldType: .expiration, text: expiration)
            self?.cardFieldPresenter.set(textFieldType: .cvc, text: cvc)
        }
    }

    func cardFieldValidationResultDidChange(result: CardFieldValidationResult) {
        isCardFieldValid = result.isValid
        activatePayButtonIfNeeded()
    }
}

// MARK: - IEmailViewPresenterOutput

extension CardPaymentPresenter: IEmailViewPresenterOutput {
    func emailTextFieldDidBeginEditing(_ presenter: EmailViewPresenter) {
        cardFieldPresenter.validateWholeForm()
    }

    func emailTextField(_ presenter: EmailViewPresenter, didChangeEmail email: String, isValid: Bool) {
        activatePayButtonIfNeeded()
    }

    func emailTextFieldDidPressReturn(_ presenter: EmailViewPresenter) {
        cardFieldPresenter.validateWholeForm()
    }
}

// MARK: - ISavedCardViewPresenterOutput

extension CardPaymentPresenter: ISavedCardViewPresenterOutput {
    func savedCardPresenter(_ presenter: SavedCardViewPresenter, didRequestReplacementFor paymentCard: PaymentCard) {
        router.openCardPaymentList(
            paymentFlow: paymentFlow,
            amount: amount,
            cards: activeCards,
            selectedCard: paymentCard,
            cardListOutput: self,
            cardPaymentOutput: output,
            completion: nil
        )
    }

    func savedCardPresenter(_ presenter: SavedCardViewPresenter, didUpdateCVC cvc: String, isValid: Bool) {
        activatePayButtonIfNeeded()
    }
}

// MARK: - IPayButtonViewPresenterOutput

extension CardPaymentPresenter: IPayButtonViewPresenterOutput {
    func payButtonViewTapped(_ presenter: IPayButtonViewPresenterInput) {
        view?.hideKeyboard()
        blockViewInteraction()
        payButtonPresenter.startLoading()

        startPaymentProcess()
    }
}

// MARK: - ICardListPresenterOutput

extension CardPaymentPresenter: ICardListPresenterOutput {
    func cardList(didUpdate cards: [PaymentCard]) {
        initialActiveCards = cards
        savedCardPresenter?.updatePresentationState(for: cards)
        setupInitialStateScreen()
        activatePayButtonIfNeeded()
    }

    func cardList(willCloseAfterSelecting card: PaymentCard) {
        savedCardPresenter?.presentationState = .selected(card: card)
        activatePayButtonIfNeeded()
    }
}

// MARK: - PaymentControllerDelegate

extension CardPaymentPresenter: PaymentControllerDelegate {
    func paymentController(
        _ controller: IPaymentController,
        didFinishPayment: IPaymentProcess,
        with state: TinkoffASDKCore.GetPaymentStatePayload,
        cardId: String?,
        rebillId: String?
    ) {
        resumeViewInteraction()
        let paymentData = FullPaymentData(paymentProcess: didFinishPayment, payload: state, cardId: cardId, rebillId: rebillId)
        output?.cardPaymentWillCloseAfterFinishedPayment(with: paymentData)
        router.closeScreen { [weak self] in
            self?.output?.cardPaymentDidCloseAfterFinishedPayment(with: paymentData)
        }
    }

    func paymentController(
        _ controller: IPaymentController,
        paymentWasCancelled: IPaymentProcess,
        cardId: String?,
        rebillId: String?
    ) {
        resumeViewInteraction()
        output?.cardPaymentWillCloseAfterCancelledPayment(with: paymentWasCancelled, cardId: cardId, rebillId: rebillId)
        router.closeScreen { [weak self] in
            self?.output?.cardPaymentDidCloseAfterCancelledPayment(with: paymentWasCancelled, cardId: cardId, rebillId: rebillId)
        }
    }

    func paymentController(
        _ controller: IPaymentController,
        didFailed error: Error,
        cardId: String?,
        rebillId: String?
    ) {
        resumeViewInteraction()
        output?.cardPaymentWillCloseAfterFailedPayment(with: error, cardId: cardId, rebillId: rebillId)
        router.closeScreen { [weak self] in
            self?.output?.cardPaymentDidCloseAfterFailedPayment(with: error, cardId: cardId, rebillId: rebillId)
        }
    }
}

// MARK: - Private

extension CardPaymentPresenter {
    private func loadCards() {
        guard let cardsController = cardsController else {
            view?.hideActivityIndicator()
            setupInitialStateScreen()
            return
        }

        cardsController.getActiveCards(completion: { [weak self] result in
            guard let self = self else { return }

            self.mainDispatchQueue.async {
                switch result {
                case let .success(cards):
                    self.handleSuccessLoadCards(cards)
                case .failure:
                    self.handleFailureLoadCards()
                }
            }
        })
    }

    private func handleSuccessLoadCards(_ cards: [PaymentCard]) {
        view?.hideActivityIndicator()
        initialActiveCards = cards
        setupInitialStateScreen()
    }

    private func handleFailureLoadCards() {
        view?.hideActivityIndicator()
        setupInitialStateScreen()
    }

    private func setupInitialStateScreen() {
        createSavedCardViewPresenterIfNeeded()

        setupCellTypes()
        view?.reloadTableView()
    }

    private func createSavedCardViewPresenterIfNeeded() {
        guard let activeCard = activeCards.first else { return }

        savedCardPresenter = savedCardViewPresenterAssembly.build(output: self)
        savedCardPresenter?.presentationState = .selected(card: activeCard)
    }

    private func createCardFieldViewPresenter() -> ICardFieldViewOutput {
        cardFieldPresenterAssembly.build(output: self, isScanButtonNeeded: isCardFieldScanButtonNeeded)
    }

    private func createReceiptSwitchViewPresenter() -> ISwitchViewOutput {
        let title = Loc.Acquiring.EmailField.switchButton
        let isOn = !customerEmail.isEmpty

        let presenter = switchViewPresenterAssembly.build(title: title, isOn: isOn) { [weak self] isOn in
            guard let self = self else { return }

            if isOn {
                let getReceiptIndex = self.cellTypes.firstIndex(of: .getReceipt(self.receiptSwitchViewPresenter)) ?? 0
                let emailIndex = getReceiptIndex + 1
                self.cellTypes.insert(.emailField(self.emailPresenter), at: emailIndex)
                self.view?.insert(row: emailIndex)
            } else if let emailIndex = self.cellTypes.firstIndex(of: .emailField(self.emailPresenter)) {
                self.cellTypes.remove(at: emailIndex)
                self.view?.delete(row: emailIndex)
            }

            self.activatePayButtonIfNeeded()
            self.view?.hideKeyboard()
            self.cardFieldPresenter.validateWholeForm()
        }

        return presenter
    }

    private func createEmailViewPresenter() -> IEmailViewOutput {
        emailViewPresenterAssembly.build(customerEmail: customerEmail, output: self)
    }

    private func createPayButtonViewPresenter() -> IPayButtonViewOutput {
        let presenter = payButtonViewPresenterAssembly
            .build(
                presentationState: .payWithAmount(amount: Int(amount)),
                output: self
            )
        presenter.set(enabled: false)
        return presenter
    }

    private func setupCellTypes() {
        cellTypes = []
        activeCards.isEmpty ? cellTypes.append(.cardField(cardFieldPresenter)) : cellTypes.append(.savedCard(savedCardPresenter))

        if customerEmail.isEmpty {
            cellTypes.append(.getReceipt(receiptSwitchViewPresenter))
        } else {
            cellTypes.append(.getReceipt(receiptSwitchViewPresenter))
            cellTypes.append(.emailField(emailPresenter))
        }

        cellTypes.append(.payButton(payButtonPresenter))
    }

    private func activatePayButtonIfNeeded() {
        let isSavedCardValid = savedCardPresenter?.isValid ?? false
        let isSavedCardExist = !activeCards.isEmpty
        let isCardValid = isSavedCardExist ? isSavedCardValid : isCardFieldValid

        let isEmailFieldOn = receiptSwitchViewPresenter.isOn
        let isEmailFieldValid = emailPresenter.isEmailValid
        let isEmailValid = isEmailFieldOn ? isEmailFieldValid : true

        let isPayButtonEnabled = isCardValid && isEmailValid
        payButtonPresenter.set(enabled: isPayButtonEnabled)
    }

    private func startPaymentProcess() {
        let cardSourceData = PaymentSourceData.cardNumber(
            number: cardFieldPresenter.cardNumber,
            expDate: cardFieldPresenter.expiration,
            cvv: cardFieldPresenter.cvc
        )
        let savedCardSourceData = PaymentSourceData.savedCard(
            cardId: savedCardPresenter?.cardId ?? "",
            cvv: savedCardPresenter?.cvc
        )

        let sourceData: PaymentSourceData = activeCards.isEmpty ? cardSourceData : savedCardSourceData
        let email = receiptSwitchViewPresenter.isOn ? emailPresenter.currentEmail : nil

        let paymentFlow = (activeCards.isEmpty ? paymentFlow.withNewCardAnalytics() : paymentFlow.withSavedCardAnalytics())
            .replacing(customerEmail: email)

        paymentController.performPayment(
            paymentFlow: paymentFlow,
            paymentSource: sourceData
        )
    }

    private func blockViewInteraction() {
        isBlockingViewInteraction = true
        view?.startIgnoringInteractionEvents()
    }

    private func resumeViewInteraction() {
        view?.stopIgnoringInteractionEvents()
        isBlockingViewInteraction = false
    }
}
