//
//  ErrorKindParser.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 05.06.2024.
//

import Foundation
import TinkoffASDKCore

/// Вид ошибки
enum ErrorKind {
    case apiError(APIError)
    case networkError(NetworkError)
    case asdkError(ASDKError)
    case tPayControllerError(TinkoffPayController.Error)
    case timeout
    case noInternet
    case sslCertificateNotTrusted
    case chargeError104
    case unparsed
    case appBased3DSError(TDSFlowError)
}

/// Мапит ошибки к единому стилю - ErrorKind
protocol IErrorKindParser {
    func parse(error: Error) -> ErrorKind
}

final class ErrorKindParser: IErrorKindParser {

    /// Maps error
    /// - Parameter error: Объект ошибки
    /// - Returns: Error kind - вид ошибки
    func parse(error: Error) -> ErrorKind {
        switch error {
        // network
        case let networkError as NetworkError:
            return .networkError(networkError)

        // api failure (business error) ошибки апи errorCode != 0
        case let apiError as APIError:
            // Ошибка рекуррента (требуется новый payment Id)
            if apiError.errorCode == 104 { return .chargeError104 }
            return .apiError(apiError)

        case let tPayError as TinkoffPayController.Error:
            return .tPayControllerError(tPayError)

        case let tPayError as TinkoffPaySheetPresenter.Error:
            switch tPayError {
            case .tinkoffPayIsNotAllowed:
                return .timeout
            }

        // asdk errors
        case let asdkError as ASDKError:
            return .asdkError(asdkError)

        case let appBasedFlowError as TDSFlowError:
            return .appBased3DSError(appBasedFlowError)

        // error codes - должно быть последним кейсом
        case let nsError as NSError:
            return parseErrorCode(nsError.code)

        default:
            assertionFailure("Should not be left unparsed")
            return .unparsed
        }
    }

    private func parseErrorCode(_ code: Int) -> ErrorKind {
        switch code {
        // Проблемы с подключением к сети интернет
        case NSURLErrorNotConnectedToInternet:
            return .noInternet

        // Проблемы с сертификатом SSL
        case _ where NSError.sslErrorCodes().contains(code):
            return .sslCertificateNotTrusted

        default:
            assertionFailure("Should not be left unparsed")
            return .unparsed
        }
    }
}

private extension NSError {

    /// Список кодов SSL ошибок
    static func sslErrorCodes() -> [Int] {
        [
            NSURLErrorSecureConnectionFailed,
            NSURLErrorServerCertificateHasBadDate,
            NSURLErrorServerCertificateUntrusted,
            NSURLErrorServerCertificateHasUnknownRoot,
            NSURLErrorServerCertificateNotYetValid,
            NSURLErrorClientCertificateRejected,
            NSURLErrorClientCertificateRequired,
            NSURLErrorCannotLoadFromNetwork,
            NSURLErrorAppTransportSecurityRequiresSecureConnection,
        ]
    }
}
