//
//  RecurrentPaymentAssembly.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 03.03.2023.
//

import TinkoffASDKCore
import UIKit

final class RecurrentPaymentAssembly: IRecurrentPaymentAssembly {

    // MARK: Dependencies

    private let acquiringSdk: AcquiringSdk
    private let paymentControllerAssembly: IPaymentControllerAssembly
    private let cardsControllerAssembly: ICardsControllerAssembly
    private let errorHandlerAssembly: IErrorHandlerAssembly
    private let configuration: UISDKConfiguration

    // MARK: Initialization

    init(
        acquiringSdk: AcquiringSdk,
        paymentControllerAssembly: IPaymentControllerAssembly,
        cardsControllerAssembly: ICardsControllerAssembly,
        errorHandlerAssembly: IErrorHandlerAssembly,
        configuration: UISDKConfiguration
    ) {
        self.acquiringSdk = acquiringSdk
        self.paymentControllerAssembly = paymentControllerAssembly
        self.cardsControllerAssembly = cardsControllerAssembly
        self.errorHandlerAssembly = errorHandlerAssembly
        self.configuration = configuration
    }

    // MARK: IRecurrentPaymentAssembly

    func build(
        paymentFlow: PaymentFlow,
        rebillId: String,
        failureDelegate: IRecurrentPaymentFailiureDelegate?,
        moduleCompletion: PaymentResultCompletion?
    ) -> UIViewController {
        let paymentController = paymentControllerAssembly.paymentController()
        let cardsController = paymentFlow.customerKey.map {
            cardsControllerAssembly.cardsController(customerKey: $0, addCardOptions: .empty)
        }

        let validator = CardRequisitesValidator()
        let paymentSystemResolver = PaymentSystemResolver()
        let bankResolver = BankResolver()

        let savedCardViewPresenterAssembly = SavedCardViewPresenterAssembly(
            validator: validator,
            paymentSystemResolver: paymentSystemResolver,
            bankResolver: bankResolver
        )

        let moneyFormatter = MoneyFormatter.shared
        let payButtonViewPresenterAssembly = PayButtonViewPresenterAssembly(moneyFormatter: moneyFormatter)

        let presenter = RecurrentPaymentPresenter(
            savedCardViewPresenterAssembly: savedCardViewPresenterAssembly,
            payButtonViewPresenterAssembly: payButtonViewPresenterAssembly,
            paymentController: paymentController,
            cardsController: cardsController,
            paymentFlow: paymentFlow,
            mainDispatchQueue: DispatchQueue.main,
            rebillId: rebillId,
            amount: paymentFlow.amount,
            shouldShowPaymentNotifications: configuration.showPaymentNotifications,
            errorHandler: errorHandlerAssembly.assemble(),
            failureDelegate: failureDelegate,
            moduleCompletion: moduleCompletion
        )

        let tableContentProvider = RecurrentPaymentTableContentProvider()

        let view = RecurrentPaymentViewController(presenter: presenter, tableContentProvider: tableContentProvider)
        presenter.view = view

        paymentController.delegate = presenter
        paymentController.webFlowDelegate = view

        let container = PullableContainerViewController(content: view)
        view.pullableContentDelegate = container

        return container
    }
}
