//
//  RecurrentPaymentPresenter.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 03.03.2023.
//

import Foundation
import TinkoffASDKCore

final class RecurrentPaymentPresenter: IRecurrentPaymentViewOutput {

    // MARK: Dependencies

    weak var view: IRecurrentPaymentViewInput?

    private let savedCardViewPresenterAssembly: ISavedCardViewPresenterAssembly
    private let payButtonViewPresenterAssembly: IPayButtonViewPresenterAssembly
    private let paymentController: IPaymentController
    private let cardsController: ICardsController?
    private var paymentFlow: PaymentFlow
    private let dispatchQueueType: IDispatchQueue.Type
    private let rebillId: String
    private let amount: Int64
    private let shouldShowPaymentNotifications: Bool
    private let errorHandler: IErrorHandler
    private weak var failureDelegate: IRecurrentPaymentFailiureDelegate?
    private var moduleCompletion: PaymentResultCompletion?

    // MARK: Child Presenters

    private lazy var savedCardPresenter = savedCardViewPresenterAssembly.build(output: self)
    private lazy var payButtonPresenter = createPayButtonViewPresenter()

    // MARK: State

    private var cellTypes: [RecurrentPaymentCellType] = []
    private var moduleResult: PaymentResult = .cancelled()
    private var additionalInitData: AdditionalData = .empty()
    private var repeatAction: (() -> Void)?

    // MARK: Initialization

    init(
        savedCardViewPresenterAssembly: ISavedCardViewPresenterAssembly,
        payButtonViewPresenterAssembly: IPayButtonViewPresenterAssembly,
        paymentController: IPaymentController,
        cardsController: ICardsController?,
        paymentFlow: PaymentFlow,
        mainDispatchQueue: IDispatchQueue,
        rebillId: String,
        amount: Int64,
        shouldShowPaymentNotifications: Bool,
        errorHandler: IErrorHandler,
        failureDelegate: IRecurrentPaymentFailiureDelegate?,
        moduleCompletion: PaymentResultCompletion?
    ) {
        self.savedCardViewPresenterAssembly = savedCardViewPresenterAssembly
        self.payButtonViewPresenterAssembly = payButtonViewPresenterAssembly
        self.paymentController = paymentController
        self.cardsController = cardsController
        self.paymentFlow = paymentFlow
        dispatchQueueType = type(of: mainDispatchQueue)
        self.rebillId = rebillId
        self.amount = amount
        self.shouldShowPaymentNotifications = shouldShowPaymentNotifications
        self.errorHandler = errorHandler
        self.failureDelegate = failureDelegate
        self.moduleCompletion = moduleCompletion
    }

    private func handle(errorHandlingResult: ErrorHandlingResult, repeatActionIfNeeded: (() -> Void)?) {
        repeatAction = repeatActionIfNeeded
        switch errorHandlingResult {
        case let .show(stub, _):
            showCommonSheetIfNeeded(for: stub.commonSheetState)
        default: assertionFailure()
        }
    }
}

// MARK: - IRecurrentPaymentViewOutput

extension RecurrentPaymentPresenter {
    func viewDidLoad() {
        view?.showCommonSheet(state: .plainProcessing, animatePullableContainerUpdates: false)
        paymentController.performPayment(paymentFlow: paymentFlow, paymentSource: .parentPayment(rebuidId: rebillId))
    }

    func viewWasClosed() {
        moduleCompletion?(moduleResult)
        moduleCompletion = nil
    }

    func numberOfRows() -> Int {
        cellTypes.count
    }

    func cellType(at indexPath: IndexPath) -> RecurrentPaymentCellType {
        cellTypes[indexPath.row]
    }

    func commonSheetViewDidTapPrimaryButton(status: CommonSheetState.Status) {
        if case let .failed(errorStub) = status {
            switch errorStub {
            case .notLoaded, .timeoutRedCross:
                repeatAction?()
            default:
                view?.closeView()
            }
        } else {
            view?.closeView()
        }
    }
}

// MARK: - ISavedCardViewPresenterOutput

extension RecurrentPaymentPresenter: ISavedCardViewPresenterOutput {
    func savedCardPresenter(
        _ presenter: SavedCardViewPresenter,
        didUpdateCVC cvc: String,
        isValid: Bool
    ) {
        activatePayButtonIfNeeded()
    }
}

// MARK: - IPayButtonViewPresenterOutput

extension RecurrentPaymentPresenter: IPayButtonViewPresenterOutput {
    func payButtonViewTapped(_ presenter: IPayButtonViewPresenterInput) {
        view?.hideKeyboard()
        startPaymentWithSavedCard()
    }
}

// MARK: - ChargePaymentControllerDelegate

extension RecurrentPaymentPresenter: ChargePaymentControllerDelegate {
    func paymentController(
        _ controller: IPaymentController,
        didFinishPayment paymentProcess: IPaymentProcess,
        with state: GetPaymentStatePayload,
        cardId: String?,
        rebillId: String?
    ) {
        moduleResult = .succeeded(state.toPaymentInfo())
        showCommonSheetIfNeeded(for: .paid(amount: paymentFlow.formattedAmountString()))
    }

    func paymentController(
        _ controller: IPaymentController,
        didFailed error: Error,
        cardId: String?,
        rebillId: String?
    ) {
        moduleResult = .failed(error)
        let result = errorHandler.handle(error: error, screen: .recurrent, event: .payment)
        handle(errorHandlingResult: result, repeatActionIfNeeded: { [weak self] in self?.viewDidLoad() })
    }

    func paymentController(
        _ controller: IPaymentController,
        paymentWasCancelled paymentProcess: IPaymentProcess,
        cardId: String?,
        rebillId: String?
    ) {
        moduleResult = .cancelled()
        view?.closeView()
    }

    func paymentController(
        _ controller: IPaymentController,
        shouldRepeatWithRebillId rebillId: String,
        failedPaymentProcess: IPaymentProcess,
        additionalInitData: AdditionalData?,
        error: Error
    ) {
        moduleResult = .failed(error)
        self.additionalInitData = additionalInitData ?? .empty()
        paymentFlow = paymentFlow.mergePaymentDataIfNeeded(initData: additionalInitData?.data)
        getSavedCard(with: rebillId, error: error)
    }
}

// MARK: - Private

extension RecurrentPaymentPresenter {
    private func createPayButtonViewPresenter() -> IPayButtonViewOutput {
        let presenter = payButtonViewPresenterAssembly
            .build(
                presentationState: .payWithAmount(amount: Int(amount)),
                output: self
            )
        presenter.set(enabled: false)
        return presenter
    }

    private func getSavedCard(with rebillId: String, error: Error) {
        guard let cardsController = cardsController else {
            let customerKeyError = ASDKError(code: .missingCustomerKey, underlyingError: error)
            moduleResult = .failed(customerKeyError)
            let result = errorHandler.handle(error: customerKeyError, screen: .recurrent, event: .payment)
            handle(errorHandlingResult: result, repeatActionIfNeeded: nil)
            return
        }

        cardsController.getActiveCards { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(activeCards):
                if let savedCard = activeCards.first(where: { $0.parentPaymentId == Int64(rebillId) }) {
                    self.savedCardPresenter.presentationState = .selected(card: savedCard, showChangeDescription: false)
                    self.cellTypes = [.savedCard(self.savedCardPresenter), .payButton(self.payButtonPresenter)]
                    self.view?.reloadData()
                    self.view?.hideCommonSheet()
                    self.savedCardPresenter.activateCVCField()
                } else {
                    self.showCommonSheetIfNeeded(for: VisualErrorStub.paymentFailure.commonSheetState)
                }
            case let .failure(error):
                self.moduleResult = .failed(error)
                let result = self.errorHandler.handle(error: error, screen: .recurrent, event: .payment)
                handle(errorHandlingResult: result, repeatActionIfNeeded: { [weak self] in
                    self?.getSavedCard(with: rebillId, error: error)
                })
            }
        }
    }

    private func activatePayButtonIfNeeded() {
        payButtonPresenter.set(enabled: savedCardPresenter.isValid)
    }

    private func showCommonSheetIfNeeded(for state: CommonSheetState) {
        if shouldShowPaymentNotifications {
            view?.showCommonSheet(state: state)
        } else {
            view?.closeView()
        }
    }

    private func startPaymentWithSavedCard() {
        guard let cardId = savedCardPresenter.cardId, let cvc = savedCardPresenter.cvc else {
            return
        }

        switch paymentFlow {
        case let .full(paymentOptions):
            paymentController.performInitPayment(
                paymentOptions: paymentOptions,
                paymentSource: .savedCard(cardId: cardId, cvv: cvc)
            )
        case let .finish(paymentOptions):
            failureDelegate?.recurrentPaymentNeedRepeatInit(additionalInitData: additionalInitData) { [weak self] result in
                guard let self = self else { return }

                self.dispatchQueueType.performOnMain {
                    switch result {
                    case let .success(paymentId):
                        self.paymentController.performFinishPayment(
                            paymentOptions: paymentOptions.updated(with: paymentId),
                            paymentSource: .savedCard(cardId: cardId, cvv: cvc)
                        )
                    case let .failure(error):
                        self.moduleResult = .failed(error)
                        let result = self.errorHandler.handle(error: error, screen: .recurrent, event: .payment)
                        self.handle(
                            errorHandlingResult: result,
                            repeatActionIfNeeded: { [weak self] in self?.startPaymentWithSavedCard() }
                        )
                    }
                }
            }
        }

        payButtonPresenter.startLoading()
    }
}
