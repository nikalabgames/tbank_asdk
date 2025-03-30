//
//  SBPPaymentSheetAssembly.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 17.01.2023.
//

import TinkoffASDKCore
import UIKit

final class SBPPaymentSheetAssembly: ISBPPaymentSheetAssembly {

    // MARK: Dependencies

    private let acquiringSdk: AcquiringSdk
    private let errorHandlerAssembly: IErrorHandlerAssembly
    private let configuration: UISDKConfiguration

    // MARK: Initialization

    init(
        acquiringSdk: AcquiringSdk,
        errorHandlerAssembly: IErrorHandlerAssembly,
        configuration: UISDKConfiguration
    ) {
        self.acquiringSdk = acquiringSdk
        self.errorHandlerAssembly = errorHandlerAssembly
        self.configuration = configuration
    }

    // MARK: ISBPPaymentSheetAssembly

    func build(
        paymentId: String,
        paymentFlow: PaymentFlow,
        output: ISBPPaymentSheetPresenterOutput?,
        isPresentingOverMainForm: Bool
    ) -> UIViewController {
        let paymentStatusService = PaymentStatusService(paymentService: acquiringSdk)
        let repeatedRequestHelper = RepeatedRequestHelper()
        let presenter = SBPPaymentSheetPresenter(
            output: output,
            paymentStatusService: paymentStatusService,
            repeatedRequestHelper: repeatedRequestHelper,
            mainDispatchQueue: DispatchQueue.main,
            errorHandler: errorHandlerAssembly.assemble(),
            requestRepeatCount: configuration.paymentStatusRetriesCount,
            paymentFlow: paymentFlow,
            paymentId: paymentId,
            shouldShowPaymentNotifications: configuration.showPaymentNotifications,
            isPresentingOverMainForm: isPresentingOverMainForm
        )

        let sheetView = CommonSheetViewController(presenter: presenter)
        presenter.view = sheetView

        let container = PullableContainerViewController(content: sheetView)
        sheetView.pullableContentDelegate = container
        return container
    }
}
