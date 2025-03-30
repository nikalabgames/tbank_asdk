//
//  SBPPaymentSheetPresenter.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 17.01.2023.
//

import Foundation
import TinkoffASDKCore

/// Презентер для управления платежной шторкой в разделе СБП
/// После показа, начинается повторяющаяся серия запросов для получения статуса с интервалом в 3 секунды
/// Количество таких запросов `requestRepeatCount` по умолчанию установленно в 10, мерч может сам установить этот параметр как ему хочется
final class SBPPaymentSheetPresenter: ICommonSheetPresenter {

    // MARK: Dependencies

    weak var view: ICommonSheetView?

    private weak var output: ISBPPaymentSheetPresenterOutput?

    private let paymentStatusService: IPaymentStatusService
    private let repeatedRequestHelper: IRepeatedRequestHelper
    private let mainDispatchQueue: IDispatchQueue
    private let errorHandler: IErrorHandler
    private let shouldShowPaymentNotifications: Bool
    private let isPresentingOverMainForm: Bool

    // MARK: Properties

    private let paymentId: String
    private let paymentFlow: PaymentFlow
    private var requestRepeatCount: Int
    private var canDismissView = true
    private var isRequestRepeatAllowed: Bool { requestRepeatCount > 0 }

    private var currentViewState: CommonSheetState = .sbpSheetWaiting
    private var lastPaymentInfo: PaymentResult.PaymentInfo?
    private var lastGetPaymentStatusError: Error?

    private var shouldCloseViewOverMainForm: Bool {
        isPresentingOverMainForm && !shouldShowPaymentNotifications
    }

    // MARK: Initialization

    init(
        output: ISBPPaymentSheetPresenterOutput?,
        paymentStatusService: IPaymentStatusService,
        repeatedRequestHelper: IRepeatedRequestHelper,
        mainDispatchQueue: IDispatchQueue,
        errorHandler: IErrorHandler,
        requestRepeatCount: Int,
        paymentFlow: PaymentFlow,
        paymentId: String,
        shouldShowPaymentNotifications: Bool,
        isPresentingOverMainForm: Bool
    ) {
        self.output = output
        self.paymentStatusService = paymentStatusService
        self.repeatedRequestHelper = repeatedRequestHelper
        self.requestRepeatCount = requestRepeatCount
        self.mainDispatchQueue = mainDispatchQueue
        self.errorHandler = errorHandler
        self.paymentId = paymentId
        self.shouldShowPaymentNotifications = shouldShowPaymentNotifications
        self.isPresentingOverMainForm = isPresentingOverMainForm
        self.paymentFlow = paymentFlow
    }
}

// MARK: - ICommonSheetPresenter

extension SBPPaymentSheetPresenter {
    func viewDidLoad() {
        view?.update(state: currentViewState, animatePullableContainerUpdates: false)
        getPaymentStatus()
    }

    func primaryButtonTapped(status: CommonSheetState.Status) {
        view?.close()
    }

    func secondaryButtonTapped() {
        view?.close()
    }

    func canDismissViewByUserInteraction() -> Bool {
        canDismissView
    }

    func viewWasClosed() {
        switch currentViewState {
        // swiftlint:disable empty_enum_arguments
        case .paid(amount: paymentFlow.formattedAmountString()):
            guard let lastPaymentInfo = lastPaymentInfo else {
                output?.sbpPaymentSheet(completedWith: .failed(ASDKError(code: .unknown)))
                return
            }

            output?.sbpPaymentSheet(completedWith: .succeeded(lastPaymentInfo))
        case .sbpSheetWaiting:
            output?.sbpPaymentSheet(completedWith: .cancelled(lastPaymentInfo))
        case VisualErrorStub.paymentFailure.commonSheetState:
            output?.sbpPaymentSheet(completedWith: .failed(ASDKError(code: .rejected)))
        case VisualErrorStub.timeoutSandWatchMakeNewPayment.commonSheetState:
            output?.sbpPaymentSheet(completedWith: .failed(ASDKError(code: .timeout, underlyingError: lastGetPaymentStatusError)))
        default:
            // во всех остальных кейсах, закрытие шторки должно быть невозможно
            break
        }
    }
}

// MARK: - Private

extension SBPPaymentSheetPresenter {

    private func getPaymentStatus() {
        guard isRequestRepeatAllowed else { return }
        requestRepeatCount -= 1

        repeatedRequestHelper.executeWithWaitingIfNeeded { [weak self] in
            guard let self = self else { return }
            self.paymentStatusService.getPaymentState(paymentId: self.paymentId) { [weak self] result in
                self?.mainDispatchQueue.async {
                    switch result {
                    case let .success(payload):
                        self?.handleSuccessGet(payloadInfo: payload)
                    case let .failure(error):
                        self?.handleFailureGetPaymentStatus(error)
                    }
                }
            }
        }
    }

    private func handleSuccessGet(payloadInfo: GetPaymentStatePayload) {
        lastPaymentInfo = payloadInfo.toPaymentInfo()

        switch payloadInfo.status {
        case .formShowed, .authorizing:
            if isRequestRepeatAllowed {
                canDismissView = true
                let newState: CommonSheetState = payloadInfo.status == .formShowed ? .sbpSheetWaiting : .processing
                viewUpdateStateIfNeeded(newState: newState)
                getPaymentStatus()
            } else {
                canDismissView = true
                viewUpdateStateIfNeeded(newState: VisualErrorStub.timeoutSandWatchMakeNewPayment.commonSheetState)
            }
        case .authorized, .confirming, .confirmed:
            canDismissView = true
            viewUpdateStateIfNeeded(newState: .paid(amount: paymentFlow.formattedAmountString()))
        case .rejected:
            canDismissView = true
            viewUpdateStateIfNeeded(newState: VisualErrorStub.paymentFailure.commonSheetState)
        case .deadlineExpired:
            canDismissView = true
            viewUpdateStateIfNeeded(newState: VisualErrorStub.timeoutSandWatchMakeNewPayment.commonSheetState)
        default:
            canDismissView = true
            if isRequestRepeatAllowed {
                viewUpdateStateIfNeeded(newState: .sbpSheetWaiting)
                getPaymentStatus()
            } else {
                // если не смогли получить статус который обрабатываем
                // показываем таймаут
                viewUpdateStateIfNeeded(newState: VisualErrorStub.timeoutSandWatchMakeNewPayment.commonSheetState)
            }
        }
    }

    private func handleFailureGetPaymentStatus(_ error: Error) {
        if isRequestRepeatAllowed {
            getPaymentStatus()
        } else {
            canDismissView = true
            lastGetPaymentStatusError = error
            let result = errorHandler.handle(error: error, screen: .sbpQr, event: .payment)
            handleErrorResult(result)
        }
    }

    private func handleErrorResult(_ result: ErrorHandlingResult) {
        switch result {
        case let .show(stub, .notification):
            viewUpdateStateIfNeeded(newState: stub.commonSheetState)
        default: assertionFailure()
        }
    }

    private func viewUpdateStateIfNeeded(newState: CommonSheetState) {
        guard currentViewState != newState else { return }
        currentViewState = newState

        if shouldShowPaymentNotifications {
            view?.update(state: currentViewState)
        } else {
            closeViewIfNeeded()
        }
    }

    private func closeViewIfNeeded() {
        if shouldCloseViewOverMainForm {
            viewWasClosed()
        } else {
            view?.close()
        }
    }
}

extension CommonSheetState {
    static var sbpSheetWaiting: CommonSheetState {
        CommonSheetState(
            status: .processing,
            title: Loc.CommonSheet.PaymentWaiting.title,
            secondaryButtonTitle: Loc.CommonSheet.PaymentWaiting.secondaryButton
        )
    }
}
