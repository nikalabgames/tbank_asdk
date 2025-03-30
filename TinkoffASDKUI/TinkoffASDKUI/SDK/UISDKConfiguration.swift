//
//  UISDKConfiguration.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 24.12.2022.
//

import Foundation
import TinkoffASDKCore

/// Конфигурация `TinkoffASDKUI`
public struct UISDKConfiguration {
    /// Запрашивает данные и способ аутентификации для `WKWebView`
    let webViewAuthChallengeService: IWebViewAuthChallengeService?

    /// Отвечает за максимальное количество запросов на обновление статуса платежа. Можно установить любое положительное значение.
    ///
    /// Запросы обновления статуса осуществляются с минимальным интервалом в 3 секунды между друг другом
    /// По умолчанию будет осуществлено 10 запросов, по истечении которых юзер получит уведомление об истечении времени, отведенного на оплату
    let paymentStatusRetriesCount: Int

    /// Тип проверки при привязке карты
    ///
    /// По умолчанию `no`
    let addCardCheckType: PaymentCardCheckType

    /// Показывать ли шторки оплаты для успеха/ошибок
    ///
    /// Передавайте `false` - если хотите использовать
    /// свои экраны уведомлений об успешной оплате / ошибке
    ///
    /// По умолчанию `true`
    let showPaymentNotifications: Bool

    /// Инициализация конфигурации `TinkoffASDKUI`
    /// - Parameter webViewAuthChallengeService: Запрашивает данные и способ аутентификация для `WKWebView`
    /// - Parameter paymentStatusRetriesCount: Максимальное количество запросов на обновление статуса платежа
    /// - Parameter addCardCheckType: Тип проверки при привязке карты
    /// - Parameter shouldHideLogoOnMainForm: Прячет логотопи кассы на платежной форме
    /// - Parameter showPaymentNotifications: Показывать ли шторки уведомлений для оплаты - успех/ошибка
    ///
    public init(
        webViewAuthChallengeService: IWebViewAuthChallengeService? = nil,
        paymentStatusRetriesCount: Int = 10,
        addCardCheckType: PaymentCardCheckType = .no,
        showPaymentNotifications: Bool = true
    ) {
        self.webViewAuthChallengeService = webViewAuthChallengeService
        self.paymentStatusRetriesCount = paymentStatusRetriesCount
        self.addCardCheckType = addCardCheckType
        self.showPaymentNotifications = showPaymentNotifications
    }
}
