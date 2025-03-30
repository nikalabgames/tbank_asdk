//
//  ISBPBanksRouter.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 26.12.2022.
//

import TinkoffASDKCore

protocol ISBPBanksRouter {
    func showDidNotFindBankAppAlert()
    func closeScreen(completion: VoidBlock?)

    func show(
        banks: [SBPBank],
        qrPayload: GetQRPayload?,
        paymentFlow: PaymentFlow,
        paymentSheetOutput: ISBPPaymentSheetPresenterOutput?,
        isPresentingOverMainForm: Bool
    )

    func showPaymentSheet(
        paymentId: String,
        paymentFlow: PaymentFlow,
        output: ISBPPaymentSheetPresenterOutput?,
        isPresentingOverMainForm: Bool
    )
}

extension ISBPBanksRouter {
    func closeScreen() {
        closeScreen(completion: nil)
    }
}
