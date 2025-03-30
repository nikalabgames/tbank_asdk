//
//  PaymentErrorHandler.swift
//  TinkoffASDKUI-Unit-Tests
//
//  Created by Ivan Glushko on 28.08.2024.
//

import Foundation

protocol IPaymentErrorHandler {
    /// Обработка ошибок в момент оплаты на экране
    func handle(
        errorKind: ErrorKind,
        isMainForm: Bool,
        info: [ErrorHandlerInfoKey: Any]
    ) -> ErrorHandlingResult
}

final class PaymentErrorHandler: IPaymentErrorHandler {

    func handle(
        errorKind: ErrorKind,
        isMainForm: Bool,
        info: [ErrorHandlerInfoKey: Any]
    ) -> ErrorHandlingResult {

        let paymentFailureStub: () -> VisualErrorStub = {
            if let canMakeNewPayment = info[.mainFormCanMakePaymentIdAgain] as? Bool, canMakeNewPayment {
                return .paymentFailureMakeNewPayment
            } else {
                return .paymentFailure
            }
        }

        let showPaymentFailureNotification: ErrorHandlingResult = .show(paymentFailureStub(), .notification)
        let showTimeoutNotification: ErrorHandlingResult = isMainForm
            ? .show(.timeoutSandWatchMakeNewPayment, .notification)
            : .show(.timeoutSandWatch, .notification)

        switch errorKind {

        case let .networkError(networkError):
            switch networkError {
            case .transportError, .serverError, .failedToCreateRequest, .emptyResponse:
                return showPaymentFailureNotification
            }

        case .timeout:
            return showTimeoutNotification

        case .sslCertificateNotTrusted, .noInternet, .apiError:
            return showPaymentFailureNotification

        case let .asdkError(asdkError):
            switch asdkError.code {
            case .failStatus, .missingCustomerKey, .rejected, .unknown:
                return showPaymentFailureNotification
            case .timeout:
                return showTimeoutNotification
            }

        case let .tPayControllerError(error):
            switch error {
            case .didNotWaitForSuccessfulPaymentState:
                return showTimeoutNotification
            case .couldNotOpenTinkoffPayApp:
                return .unhandled
            case .didReceiveFailedPaymentState:
                return showPaymentFailureNotification
            }

        case let .appBased3DSError(error):
            switch error {
            case .runtimeError, .protocolError, .invalidPaymentSystem, .updatingCertsError:
                return showPaymentFailureNotification
            case .timeout:
                return showTimeoutNotification
            }

        case .unparsed, .chargeError104:
            return .unhandled
        }
    }
}
