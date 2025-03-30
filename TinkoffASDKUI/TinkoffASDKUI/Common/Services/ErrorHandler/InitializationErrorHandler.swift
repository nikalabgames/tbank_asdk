//
//  InitializationErrorHandler.swift
//  TinkoffASDKUI-Unit-Tests
//
//  Created by Ivan Glushko on 28.08.2024.
//

import Foundation

protocol IInitializationErrorHandler {
    /// Обработка ошибок в момент инициализации экрана
    func handle(errorKind: ErrorKind) -> ErrorHandlingResult
}

final class InitializationErrorHandler: IInitializationErrorHandler {

    func handle(errorKind: ErrorKind) -> ErrorHandlingResult {
        let showTimeoutContainer: ErrorHandlingResult = .show(.timeoutRedCross, .insideContainer)
        let showWeHaveProblemContainer: ErrorHandlingResult = .show(.weHaveProblem, .insideContainer)

        switch errorKind {

        case let .networkError(networkError):
            var visualStub: VisualErrorStub
            switch networkError {
            case .transportError:
                visualStub = .notLoaded
            case .serverError, .failedToCreateRequest, .emptyResponse:
                visualStub = .weHaveProblem
            }
            return .show(visualStub, .insideContainer)

        case .timeout:
            return showTimeoutContainer

        case .noInternet, .sslCertificateNotTrusted:
            return .show(.notLoaded, .insideContainer)

        case .apiError:
            return showWeHaveProblemContainer

        case let .asdkError(asdkError):
            switch asdkError.code {
            case .failStatus, .missingCustomerKey, .rejected, .unknown:
                return showWeHaveProblemContainer
            case .timeout:
                return showTimeoutContainer
            }

        case .unparsed, .chargeError104, .tPayControllerError, .appBased3DSError:
            return .unhandled
        }
    }
}
