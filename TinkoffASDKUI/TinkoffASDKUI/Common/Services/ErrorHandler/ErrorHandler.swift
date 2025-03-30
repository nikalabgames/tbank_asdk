//
//  ErrorHandler.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 28.05.2024.
//

import Foundation
import TinkoffASDKCore

/// Единый обработчик ошибок
final class ErrorHandler: IErrorHandler {

    private let errorKindParser: IErrorKindParser
    private let initializationErrorHandler: IInitializationErrorHandler
    private let paymentErrorHandler: IPaymentErrorHandler

    init(
        errorKindParser: IErrorKindParser,
        initializationErrorHandler: IInitializationErrorHandler,
        paymentErrorHandler: IPaymentErrorHandler
    ) {
        self.errorKindParser = errorKindParser
        self.initializationErrorHandler = initializationErrorHandler
        self.paymentErrorHandler = paymentErrorHandler
    }

    func handle(
        error: Error,
        screen: SdkScreen,
        event: ScreenEvent,
        info: [ErrorHandlerInfoKey: Any]
    ) -> ErrorHandlingResult {
        let result = formErrorHandlingResult(error: error, screen: screen, event: event, info: info)
        if case .unhandled = result { assertionFailure("No unhandled allowed") }
        return result
    }

    /// Логика обработки ошибок
    private func formErrorHandlingResult(
        error: Error,
        screen: SdkScreen,
        event: ScreenEvent,
        info: [ErrorHandlerInfoKey: Any]
    ) -> ErrorHandlingResult {

        let errorKind: ErrorKind = errorKindParser.parse(error: error)

        switch (screen, event) {
        /// Платежная форма - инициализация
        case (.mainForm, .inititialization):
            return initializationErrorHandler.handle(errorKind: errorKind)

        /// Платежная форма - оплата
        case (.mainForm, .payment):
            return paymentErrorHandler.handle(errorKind: errorKind, isMainForm: true, info: info)

        /// Платежная форма - тинькофф пей - инициализация
        case (.mainFormTinkoffPay, .inititialization):
            return .route(.tinkoffPayLanding)

        /// Платежная форма - тинькофф пей - оплата
        case (.mainFormTinkoffPay, .payment):
            return paymentErrorHandler.handle(errorKind: errorKind, isMainForm: true, info: info)

        /// Оплата картой - инициализация
        case (.cardPayment, .inititialization):
            if case let .apiError(err) = errorKind, err.errorCode == .noSuchCustomerErrorCode {
                return .show(.noCardsInCardList, .insideContainer)
            }
            return initializationErrorHandler.handle(errorKind: errorKind)

        /// Оплата картой - оплата
        case (.cardPayment, .payment):
            return paymentErrorHandler.handle(errorKind: errorKind, isMainForm: false, info: info)

        /// Оплата картой - удалить карту
        case (.cardPayment, .removeCard):
            return .showToast(.failedToRemoveCard)

        /// Список карт - инициализация
        case (.cardList, .inititialization):
            if case let .apiError(err) = errorKind, err.errorCode == .noSuchCustomerErrorCode {
                return .show(.noCardsInCardList, .insideContainer)
            }
            return initializationErrorHandler.handle(errorKind: errorKind)

        /// Список карт - удалить карту
        case (.cardList, .removeCard):
            return .showToast(.failedToRemoveCard)

        /// Добавление карты - добавить карту
        case (.addCard, .addCard):
            if case let .apiError(err) = errorKind, err.errorCode == .alreadyHasSuchCardError {
                return .showToast(.cardIsAlreadyAdded)
            }
            return .showToast(.failedToAddCard)

        /// СБП список банков - инициализация
        case (.sbpBankList, .inititialization):
            return initializationErrorHandler.handle(errorKind: errorKind)

        /// СБП шторка оплаты - оплата
        case (.sbpPaymentSheet, .payment):
            if case .timeout = errorKind {
                return .show(.timeoutSandWatchMakeNewPayment, .notification)
            }
            return .show(.paymentFailure, .notification)

        /// СБП QR - инициализация
        case (.sbpQr, .inititialization):
            return .show(.timeoutRedCross, .insideContainer)

        /// СБП QR - оплата
        case (.sbpQr, .payment):
            return .show(.paymentFailure, .insideContainer)

        /// TinkoffPay - инициализация
        case (.tPay, .inititialization):
            if case .timeout = errorKind {
                return .show(.timeoutRedCross, .insideContainer)
            }
            return .multistep([
                .route(.tinkoffPayLanding),
                .show(.paymentFailure, .insideContainer),
            ])

        /// TinkoffPay - оплата
        case (.tPay, .payment):
            if case .timeout = errorKind {
                return .show(.timeoutSandWatchMakeNewPayment, .insideContainer)
            }
            return paymentErrorHandler.handle(errorKind: errorKind, isMainForm: false, info: info)

        /// Рекуррент - оплата
        case (.recurrent, .payment):
            if case let .asdkError(asdkError) = errorKind {
                if asdkError.code == .missingCustomerKey {
                    return .show(.paymentFailure, .insideContainer)
                }
            }

            return paymentErrorHandler.handle(errorKind: errorKind, isMainForm: false, info: info)

        default:
            return .unhandled
        }
    }
}

private extension Int {
    /// Нет такого покупателя
    static let noSuchCustomerErrorCode = 7
    /// Карта уже добавлена
    static let alreadyHasSuchCardError = 510
}
