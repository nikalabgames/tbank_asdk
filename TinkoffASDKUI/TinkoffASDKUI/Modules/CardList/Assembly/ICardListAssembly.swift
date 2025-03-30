//
//  ICardListAssembly.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 22.02.2023.
//

import TinkoffASDKCore
import UIKit

/// Объект, осуществляющий сборку модуля `CardList` для различных пользовательских сценариев
protocol ICardListAssembly {
    /// Создает экран со списком карт, обернутый в `UINavigationController`
    ///
    /// Используется для отображения списка карт в сценарии управления картами, доступного при открытии из родительского приложения
    /// - Parameter customerKey: Идентификатор покупателя в системе Продавца
    /// - Parameter cardScannerDelegate: Объект, который принимает решение какой экран показать в случае если нажали на кнопку сканера карты
    /// - Parameter addCardOptions: Параметры для флоу привязки карты
    /// - Parameter completion: Событие, сообщающее о закрытии экрана 'Список сохраненных карт'
    /// - Returns: `UINavigationController`
    func cardsPresentingNavigationController(
        customerKey: String,
        addCardOptions: AddCardOptions,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: VoidBlock?
    ) -> UINavigationController

    /// Создает экран со списком карт, с выбранной картой по-умолчанию.
    ///
    /// По нажатии на ячейку карты экран отправляет уведомление о закрытии, через `ICardListPresenterOutput`, возвращая эту карту.
    /// Кнопка добавления новой карты в этом сценарии пушит в `UINavigationController` экран оплаты по новой карте.
    /// Уведомление о закрытии этой цепочки экранов после совершенной оплаты отправляются через `ICardPaymentPresenterModuleOutput`
    /// Замыкание с результатом, вызываемое после закрытия экрана 'Список сохраненных карт'
    func cardPaymentList(
        customerKey: String,
        cards: [PaymentCard],
        selectedCard: PaymentCard,
        paymentFlow: PaymentFlow,
        amount: Int64,
        output: ICardListPresenterOutput?,
        cardPaymentOutput: ICardPaymentPresenterModuleOutput?,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: VoidBlock?
    ) -> UIViewController
}
