//
//  ICardPaymentRouter.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 20.01.2023.
//

import TinkoffASDKCore

protocol ICardPaymentRouter {
    func closeScreen(completion: VoidBlock?)

    func showCardScanner(completion: @escaping CardScannerCompletion)

    func openCardPaymentList(
        paymentFlow: PaymentFlow,
        amount: Int64,
        cards: [PaymentCard],
        selectedCard: PaymentCard,
        cardListOutput: ICardListPresenterOutput?,
        cardPaymentOutput: ICardPaymentPresenterModuleOutput?,
        completion: VoidBlock?
    )
}

extension ICardPaymentRouter {
    /// Для удобства / красоты
    func closeScreen() {
        closeScreen(completion: nil)
    }
}
