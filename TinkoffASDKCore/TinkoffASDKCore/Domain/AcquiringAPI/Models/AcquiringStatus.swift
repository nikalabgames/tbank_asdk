//
//  AcquiringStatus.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 07.10.2022.
//

import Foundation

/// Состояние операции API эквайринга
public enum AcquiringStatus: String, Decodable, Equatable {
    /// Платёж создан
    case new = "NEW"
    /// Отмена платежа
    case cancelled = "CANCELLED"
    case preauthorizing = "PREAUTHORIZING"
    /// Покупатель перенаправлен на страницу оплаты
    case formshowed = "FORMSHOWED"
    /// Система начала обработку оплаты платежа
    case authorizing = "AUTHORIZING"
    /// Система начала проверку оплаты платежа
    case paychecking = "PAY_CHECKING"
    /// Средства заблокированы, но не списаны
    case authorized = "AUTHORIZED"
    /// Покупатель начал аутентификацию по протоколу `3DSecure`. Статус может быть конечным, если клиент закрыл страницу ACS или не ввел код подтверждения 3Ds
    case checking3ds = "3DS_CHECKING"
    /// Покупатель завершил проверку 3DSecure
    case checked3ds = "3DS_CHECKED"
    /// Начало отмены блокировки средств
    case reversing = "REVERSING"
    /// Произведена частичная отмена блокироваки денежных средств
    case partialReversed = "PARTIAL_REVERSED"
    /// Денежные средства разблокированы
    case reversed = "REVERSED"
    /// Начало списания денежных средств
    case confirming = "CONFIRMING"
    /// Денежные средства успешно списаны
    case confirmed = "CONFIRMED"
    /// Проверяем списание средств
    case confirmChecking = "CONFIRM_CHECKING"
    /// Начало возврата денежных средств
    case refunding = "REFUNDING"
    /// Начало возврата денежных средств
    case asyncRefunding = "ASYNC_REFUNDING"
    /// Произведен возврат денежных средств
    case refunded = "REFUNDED"
    /// Отмена возврата денежных средств
    case cancelRefunded = "CANCEL_REFUNDED"
    /// Произведен частичный возврат денежных средств
    case refundedPartial = "PARTIAL_REFUNDED"
    /// Ошибка платежа. Истекли попытки оплаты
    case rejected = "REJECTED"
    case completed = "COMPLETED"
    case hold = "HOLD"
    case hold3ds = "3DSHOLD"
    case loop = "LOOP_CHECKING"
    case unknown = "UNKNOWN"
    /// Ожидаем оплату по QR-коду
    case formShowed = "FORM_SHOWED"
    /// Время отведенное на оплату закончилось
    case deadlineExpired = "DEADLINE_EXPIRED"
    /// Истекло количество попыток
    case attemptsExpired = "ATTEMPTS_EXPIRED"
    /// Ошибка аутентификации
    case authFail = "AUTH_FAIL"

    public init(rawValue: String) {
        switch rawValue {
        case "CANCELLED": self = .cancelled
        case "PREAUTHORIZING": self = .preauthorizing
        case "FORMSHOWED": self = .formshowed
        case "AUTHORIZING": self = .authorizing
        case "AUTHORIZED": self = .authorized
        case "3DS_CHECKING": self = .checking3ds
        case "3DS_CHECKED": self = .checked3ds
        case "REVERSING": self = .reversing
        case "REVERSED": self = .reversed
        case "CONFIRMING": self = .confirming
        case "CONFIRMED": self = .confirmed
        case "REFUNDING": self = .refunding
        case "REFUNDED": self = .refunded
        case "PARTIAL_REFUNDED": self = .refundedPartial
        case "REJECTED": self = .rejected
        case "COMPLETED": self = .completed
        case "HOLD": self = .hold
        case "3DSHOLD": self = .hold3ds
        case "LOOP_CHECKING": self = .loop
        case "NEW": self = .new
        case "UNKNOWN": self = .unknown
        case "FORM_SHOWED": self = .formShowed
        case "DEADLINE_EXPIRED": self = .deadlineExpired
        default: self = .unknown
        }
    }
}

public extension AcquiringStatus {

    enum CardsStatuses {

        /// Процессные статусы - начало обработки платежа
        static let processingList: [AcquiringStatus] = [
            .preauthorizing,
            .authorizing,
            .paychecking,
        ]

        /// Успешные статусы - платеж успешно совершен
        public static let successList: [AcquiringStatus] = [
            .authorized,
            .reversing,
            .partialReversed,
            .reversed,
            .confirming,
            .confirmed,
            .refunding,
            .asyncRefunding,
            .refundedPartial,
            .refunded,
            .cancelRefunded,
            .confirmChecking,
        ]

        /// Статусы ошибок - платеж не совершен
        public static let failureList: [AcquiringStatus] = [
            .cancelled,
            .authFail,
            .rejected,
            .deadlineExpired,
            .attemptsExpired,
        ]

        /// Статусы 3DSecure - проверка 3DSecure
        public static let threedsList: [AcquiringStatus] = [
            .checking3ds,
            .checked3ds,
        ]
    }
}
