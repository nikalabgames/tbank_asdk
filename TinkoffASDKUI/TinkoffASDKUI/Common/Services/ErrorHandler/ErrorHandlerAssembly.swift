//
//  ErrorHandlerAssembly.swift
//  TinkoffASDKUI-Unit-Tests
//
//  Created by Ivan Glushko on 28.08.2024.
//

import Foundation

protocol IErrorHandlerAssembly {
    func assemble() -> IErrorHandler
}

final class ErrorHandlerAssembly: IErrorHandlerAssembly {

    func assemble() -> IErrorHandler {
        ErrorHandler(
            errorKindParser: ErrorKindParser(),
            initializationErrorHandler: InitializationErrorHandler(),
            paymentErrorHandler: PaymentErrorHandler()
        )
    }
}
