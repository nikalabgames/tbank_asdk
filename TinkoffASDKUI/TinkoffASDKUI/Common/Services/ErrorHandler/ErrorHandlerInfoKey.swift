//
//  ErrorHandlerInfoKey.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 03.07.2024.
//

import Foundation

/// Ключи дополнительного контекся для ``ErrorHandler``
enum ErrorHandlerInfoKey {
    /// Платежная форма можем ли заново сформировать paymentId
    ///
    /// Для `PaymentFlow.full` - сможем / для `PaymentFlow.finish` - не сможем
    case mainFormCanMakePaymentIdAgain
}
