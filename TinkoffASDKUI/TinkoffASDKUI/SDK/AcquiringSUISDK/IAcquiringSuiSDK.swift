//
//  IAcquiringSuiSDK.swift
//  TinkoffASDKUI
//
//  Created by Sergey Galagan on 03.07.2024.
//

import TinkoffASDKCore

public protocol IAcquiringSuiSDK {
    /// Вернет SUI View - основная платежную форму с различными способами оплаты
    /// - Parameters:
    ///   - paymentFlow: Содержит тип платежа и параметры оплаты
    ///   - configuration: Конфигурация платежной формы
    ///   - cardScannerDelegate: Делегат, предоставляющий возможность отобразить карточный сканер поверх заданного экрана
    ///   - completion: Замыкание с результатом, вызываемое после закрытия экрана оплаты
    ///   - return: Возвращает обертку для SUI
    func mainFormView(
        paymentFlow: PaymentFlow,
        configuration: MainFormUIConfiguration,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView

    /// Вернет SUI View - TinkoffPay sheet
    /// - Parameters:
    ///   - paymentFlow: Содержит тип платежа и параметры оплаты
    ///   - completion: Замыкание с результатом, вызываемое после закрытия экрана оплаты
    func tinkoffPayView(
        paymentFlow: PaymentFlow,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView

    /// Вернет SUI View - Добавление карты
    func addCardView(
        customerKey: String,
        addCardOptions: AddCardOptions,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: ((AddCardResult) -> Void)?
    ) -> AsdkSuiView

    /// Вернет SUI View - Cписок карт
    /// На этом экране пользователь может ознакомиться со списком привязанных карт, удалить или добавить новую карту
    ///
    /// - Parameters:
    ///   - customerKey: Идентификатор покупателя в системе Продавца, к которому будет привязана карта
    ///   - addCardOptions: Параметры для флоу привязки карты
    ///   - cardScannerDelegate: Делегат, предоставляющий возможность отобразить карточный сканер поверх заданного экрана
    ///   - completion: Событие, сообщающее о закрытии экрана 'Список сохраненных карт'
    func cardListView(
        customerKey: String,
        addCardOptions: AddCardOptions,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: (() -> Void)?
    ) -> AsdkSuiView

    /// Вернет SUI View - СБП Список Банков
    /// Отображает экран со списком приложений банков, с помощью которых можно провести оплату через `Систему быстрых платежей`
    ///
    /// - Parameters:
    ///   - paymentFlow: Содержит тип платежа и параметры оплаты
    ///   - completion: Замыкание с результатом оплаты, вызываемое после закрытия экрана оплаты `СБП`
    func sbpBanksListView(
        paymentFlow: PaymentFlow,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView

    /// Вернет SUI View - СБП Статичный QR
    /// Отображает экран с многоразовым `QR-кодом`, отсканировав который, пользователь сможет провести оплату с помощью `Системы быстрых платежей`
    ///
    /// При данном типе оплаты SDK никак не отслеживает статус платежа
    /// - Parameters:
    ///   - completion: Замыкание, вызываемое при закрытии экрана с `QR-кодом`
    func staticSbpQrView(
        completion: (() -> Void)?
    ) -> AsdkSuiView

    /// Вернет SUI View - СБП Динамический QR
    /// Отображает экран с одноразовым `QR-кодом`, отсканировав который, пользователь сможет провести оплату  с помощью `Системы быстрых платежей`
    ///
    /// При данном типе оплаты сумма и информация о платеже фиксируется, и SDK способен получить и обработать статус платежа
    /// - Parameters:
    ///   - paymentFlow: Содержит тип платежа и параметры оплаты
    ///   - completion: Замыкание с результатом оплаты, вызываемое после закрытия экрана с `QR-кодом`
    func dynamicSbpQrView(
        paymentFlow: PaymentFlow,
        completion: @escaping PaymentResultCompletion
    ) -> AsdkSuiView
}
