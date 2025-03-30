//
//  AcquiringUISDK+Ext.swift
//  TinkoffASDKUI
//
//  Created by Sergey Galagan on 26.06.2024.
//

import TinkoffASDKCore
import UIKit

/// Не явный конформанс к протоколу `IAcquiringSuiSDK` используется внутри `AcquiringSwiftUIAdapter`
extension AcquiringUISDK {

    /// SUI: Платежная форма
    func mainFormView(
        paymentFlow: PaymentFlow,
        configuration: MainFormUIConfiguration,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView {
        let viewController = mainFormAssembly.build(
            paymentFlow: paymentFlow,
            configuration: configuration,
            cardScannerDelegate: cardScannerDelegate,
            moduleCompletion: completion
        )
        return AsdkSuiView(viewController: viewController)
    }

    /// SUI: Добавление карты
    func addCardView(
        customerKey: String,
        addCardOptions: AddCardOptions,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: ((AddCardResult) -> Void)?
    ) -> AsdkSuiView {
        let navigationController = addNewCardAssembly.addNewCardNavigationController(
            customerKey: customerKey,
            addCardOptions: addCardOptions,
            cardScannerDelegate: cardScannerDelegate,
            onViewWasClosed: completion
        )
        return AsdkSuiView(viewController: navigationController)
    }

    /// SUI: Список карт
    func cardListView(
        customerKey: String,
        addCardOptions: AddCardOptions,
        cardScannerDelegate: ICardScannerDelegate?,
        completion: (() -> Void)?
    ) -> AsdkSuiView {
        let navigationController = cardListAssembly.cardsPresentingNavigationController(
            customerKey: customerKey,
            addCardOptions: addCardOptions,
            cardScannerDelegate: cardScannerDelegate,
            completion: completion
        )
        return AsdkSuiView(viewController: navigationController)
    }

    /// SUI: СБП выбор банка
    func sbpBanksListView(
        paymentFlow: PaymentFlow,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView {
        let module = sbpBanksAssembly.buildInitialModule(
            paymentFlow: paymentFlow,
            isPresentingOverMainForm: false,
            completion: completion
        )
        let navigation = UINavigationController.withElevationBar(rootViewController: module.view)
        return AsdkSuiView(viewController: navigation)
    }

    /// SUI: Tinkoff Pay
    func tinkoffPayView(
        paymentFlow: PaymentFlow,
        completion: PaymentResultCompletion?
    ) -> AsdkSuiView {
        let viewController = tinkoffPaySheetAssembly.tinkoffPaySheet(paymentFlow: paymentFlow, completion: completion)
        return AsdkSuiView(viewController: viewController)
    }

    /// SUI: СБП статический QR
    func staticSbpQrView(
        completion: (() -> Void)?
    ) -> AsdkSuiView {
        let viewContoller = sbpQrAssembly.buildForStaticQr(moduleCompletion: completion)
        return AsdkSuiView(viewController: viewContoller)
    }

    /// SUI: СБП динамический QR
    func dynamicSbpQrView(
        paymentFlow: PaymentFlow,
        completion: @escaping PaymentResultCompletion
    ) -> AsdkSuiView {
        let viewController = sbpQrAssembly.buildForDynamicQr(paymentFlow: paymentFlow, moduleCompletion: completion)
        return AsdkSuiView(viewController: viewController)
    }
}
