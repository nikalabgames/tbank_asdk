//
//  TinkoffPaySheetAssembly.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 13.03.2023.
//

import Foundation
import TinkoffASDKCore
import UIKit

final class TinkoffPaySheetAssembly: ITinkoffPaySheetAssembly {
    // MARK: Dependencies

    private let coreSDK: AcquiringSdk
    private let tinkoffPayAssembly: ITinkoffPayAssembly
    private let tinkoffPayLandingAssembly: ITinkoffPayLandingAssembly
    private let errorHandlerAssembly: IErrorHandlerAssembly
    private let uisdkConfiguration: UISDKConfiguration

    // MARK: Init

    init(
        coreSDK: AcquiringSdk,
        tinkoffPayAssembly: ITinkoffPayAssembly,
        tinkoffPayLandingAssembly: ITinkoffPayLandingAssembly,
        errorHandlerAssembly: IErrorHandlerAssembly,
        uisdkConfiguration: UISDKConfiguration
    ) {
        self.coreSDK = coreSDK
        self.tinkoffPayAssembly = tinkoffPayAssembly
        self.tinkoffPayLandingAssembly = tinkoffPayLandingAssembly
        self.errorHandlerAssembly = errorHandlerAssembly
        self.uisdkConfiguration = uisdkConfiguration
    }

    // MARK: ITinkoffPaySheetAssembly

    func tinkoffPaySheet(paymentFlow: PaymentFlow, completion: PaymentResultCompletion?) -> UIViewController {
        let tinkoffPayController = tinkoffPayAssembly.tinkoffPayController()
        let router = TinkoffPaySheetRouter(tinkoffPayLandingAssembly: tinkoffPayLandingAssembly)

        let presenter = TinkoffPaySheetPresenter(
            router: router,
            tinkoffPayService: coreSDK,
            tinkoffPayController: tinkoffPayController,
            errorHandler: errorHandlerAssembly.assemble(),
            paymentFlow: paymentFlow,
            shouldShowPaymentNotifications: uisdkConfiguration.showPaymentNotifications,
            moduleCompletion: completion
        )

        let view = CommonSheetViewController(presenter: presenter)

        router.transitionHandler = view
        presenter.view = view
        tinkoffPayController.delegate = presenter

        let container = PullableContainerViewController(content: view)
        view.pullableContentDelegate = container

        return container
    }
}
