//
//  TinkoffPaySheetPresenter.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 13.03.2023.
//

import Foundation
import TinkoffASDKCore

final class TinkoffPaySheetPresenter {
    // MARK: Internal Types

    enum Error: Swift.Error {
        case tinkoffPayIsNotAllowed
    }

    // MARK: Dependencies

    weak var view: ICommonSheetView?

    private let router: ITinkoffPaySheetRouter
    private let tinkoffPayService: IAcquiringTinkoffPayService
    private let tinkoffPayController: ITinkoffPayController
    private let errorHandler: IErrorHandler
    private let paymentFlow: PaymentFlow
    private let shouldShowPaymentNotifications: Bool
    private var moduleCompletion: PaymentResultCompletion?

    // MARK: State

    private var moduleResult: PaymentResult = .cancelled()

    // MARK: Init

    init(
        router: ITinkoffPaySheetRouter,
        tinkoffPayService: IAcquiringTinkoffPayService,
        tinkoffPayController: ITinkoffPayController,
        errorHandler: IErrorHandler,
        paymentFlow: PaymentFlow,
        shouldShowPaymentNotifications: Bool,
        moduleCompletion: PaymentResultCompletion?
    ) {
        self.router = router
        self.tinkoffPayService = tinkoffPayService
        self.tinkoffPayController = tinkoffPayController
        self.errorHandler = errorHandler
        self.paymentFlow = paymentFlow
        self.shouldShowPaymentNotifications = shouldShowPaymentNotifications
        self.moduleCompletion = moduleCompletion
    }

    private func handle(errorHandlingResult: ErrorHandlingResult) {
        switch errorHandlingResult {
        case let .show(stub, _):
            updateViewStateIfNeeded(stub.commonSheetState)
        case .multistep([.route(.tinkoffPayLanding), .show(.paymentFailure, .insideContainer)]):
            router.openTinkoffPayLanding { [weak self] in
                self?.updateViewStateIfNeeded(VisualErrorStub.paymentFailure.commonSheetState)
            }
        default: assertionFailure()
        }
    }
}

// MARK: - ICommonSheetPresenter

extension TinkoffPaySheetPresenter: ICommonSheetPresenter {
    func viewDidLoad() {
        view?.update(state: .tinkoffPay.processing, animatePullableContainerUpdates: false)

        tinkoffPayService.getTinkoffPayStatus { [weak self] result in
            DispatchQueue.performOnMain {
                guard let self = self else { return }

                switch result {
                case let .success(payload):
                    self.handleReceivedStatus(payload: payload)
                case let .failure(error):
                    self.handleFailedStatus(error: error)
                }
            }
        }
    }

    func primaryButtonTapped(status: CommonSheetState.Status) {
        view?.close()
    }

    func secondaryButtonTapped() {
        view?.close()
    }

    func canDismissViewByUserInteraction() -> Bool {
        true
    }

    func viewWasClosed() {
        moduleCompletion?(moduleResult)
        moduleCompletion = nil
    }
}

// MARK: - TinkoffPayControllerDelegate

extension TinkoffPaySheetPresenter: TinkoffPayControllerDelegate {
    func tinkoffPayController(
        _ tinkoffPayController: ITinkoffPayController,
        didReceiveIntermediate paymentState: GetPaymentStatePayload
    ) {
        moduleResult = .cancelled(paymentState.toPaymentInfo())
    }

    func tinkoffPayController(
        _ tinkoffPayController: ITinkoffPayController,
        completedDueToInabilityToOpenTinkoffPay url: URL,
        error: Swift.Error
    ) {
        moduleResult = .failed(error)

        let result = errorHandler.handle(error: error, screen: .tPay, event: .inititialization)
        handle(errorHandlingResult: result)
    }

    func tinkoffPayController(
        _ tinkoffPayController: ITinkoffPayController,
        completedWithSuccessful paymentState: GetPaymentStatePayload
    ) {
        moduleResult = .succeeded(paymentState.toPaymentInfo())
        updateViewStateIfNeeded(.paid(amount: paymentFlow.formattedAmountString()))
    }

    func tinkoffPayController(
        _ tinkoffPayController: ITinkoffPayController,
        completedWithFailed paymentState: GetPaymentStatePayload,
        error: Swift.Error
    ) {
        moduleResult = .failed(error)
        let result = errorHandler.handle(error: error, screen: .tPay, event: .payment)
        handle(errorHandlingResult: result)
    }

    func tinkoffPayController(
        _ tinkoffPayController: ITinkoffPayController,
        completedWithTimeout paymentState: GetPaymentStatePayload,
        error: Swift.Error
    ) {
        moduleResult = .failed(error)
        let result = errorHandler.handle(error: error, screen: .tPay, event: .payment)
        handle(errorHandlingResult: result)
    }

    func tinkoffPayController(
        _ tinkoffPayController: ITinkoffPayController,
        completedWith error: Swift.Error
    ) {
        moduleResult = .failed(error)
        let result = errorHandler.handle(error: error, screen: .tPay, event: .payment)
        handle(errorHandlingResult: result)
    }
}

// MARK: - TinkoffPaySheetPresenter + Helpers

extension TinkoffPaySheetPresenter {
    private func handleReceivedStatus(payload: GetTinkoffPayStatusPayload) {
        switch payload.status {
        case let .allowed(method):
            tinkoffPayController.performPayment(paymentFlow: paymentFlow, method: method)
        case .disallowed:
            handleFailedStatus(error: Error.tinkoffPayIsNotAllowed)
        }
    }

    private func handleFailedStatus(error: Swift.Error) {
        moduleResult = .failed(error)
        let result = errorHandler.handle(error: error, screen: .tPay, event: .inititialization)
        handle(errorHandlingResult: result)
    }

    private func updateViewStateIfNeeded(_ state: CommonSheetState, animatePullableContainerUpdates: Bool = true) {
        if shouldShowPaymentNotifications {
            view?.update(state: state, animatePullableContainerUpdates: animatePullableContainerUpdates)
        } else {
            view?.close()
        }
    }
}
