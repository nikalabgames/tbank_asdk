//
//  AcquiringSwiftUIAdapter.swift
//  TinkoffASDKUI
//
//  Created by Sergey Galagan on 31.07.2024.
//

import Foundation

final class AcquiringSwiftUIAdapter: IAcquiringSuiSDK {
    private unowned let adaptee: AcquiringUISDK

    init(adaptee: AcquiringUISDK) {
        self.adaptee = adaptee
    }

    func mainFormView(
        paymentFlow: PaymentFlow,
        configuration: MainFormUIConfiguration,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView {
        adaptee.mainFormView(
            paymentFlow: paymentFlow,
            configuration: configuration,
            cardScannerDelegate: cardScannerDelegate,
            completion: completion
        )
    }

    func addCardView(
        customerKey: String,
        addCardOptions: AddCardOptions,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: ((AddCardResult) -> Void)?
    ) -> AsdkSuiView {
        adaptee.addCardView(
            customerKey: customerKey,
            addCardOptions: addCardOptions,
            cardScannerDelegate: cardScannerDelegate,
            completion: completion
        )
    }

    func cardListView(
        customerKey: String,
        addCardOptions: AddCardOptions,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: (() -> Void)?
    ) -> AsdkSuiView {
        adaptee.cardListView(
            customerKey: customerKey,
            addCardOptions: addCardOptions,
            cardScannerDelegate: cardScannerDelegate,
            completion: completion
        )
    }

    func tinkoffPayView(
        paymentFlow: PaymentFlow,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView {
        adaptee.tinkoffPayView(
            paymentFlow: paymentFlow,
            completion: completion
        )
    }

    func sbpBanksListView(
        paymentFlow: PaymentFlow,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView {
        adaptee.sbpBanksListView(
            paymentFlow: paymentFlow,
            completion: completion
        )
    }

    func staticSbpQrView(completion: (() -> Void)?) -> AsdkSuiView {
        adaptee.staticSbpQrView(completion: completion)
    }

    func dynamicSbpQrView(
        paymentFlow: PaymentFlow,
        completion: @escaping PaymentResultCompletion
    ) -> AsdkSuiView {
        adaptee.dynamicSbpQrView(paymentFlow: paymentFlow, completion: completion)
    }
}
