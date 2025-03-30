//
//  SdkScreen.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 05.06.2024.
//

import Foundation

enum SdkScreen {
    /// Платежная форма
    case mainForm
    /// Платежная форма - тинькофф пэй
    case mainFormTinkoffPay
    /// Оплата картой (новой/сохраненной)
    case cardPayment
    /// Список карт
    case cardList
    /// Добавление карты
    case addCard
    /// Т-Pay
    case tPay
    /// СБП - список банков
    case sbpBankList
    /// СБП - шторка оплаты
    case sbpPaymentSheet
    /// СБП - оплата по qr
    case sbpQr
    /// Реккурент
    case recurrent
}
