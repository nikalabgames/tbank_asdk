//
//  MainFormAssembly.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 19.01.2023.
//

import TinkoffASDKCore
import UIKit

final class MainFormAssembly: IMainFormAssembly {
    // MARK: Dependencies

    private let coreSDK: AcquiringSdk
    private let paymentControllerAssembly: IPaymentControllerAssembly
    private let cardsControllerAssembly: ICardsControllerAssembly
    private let tinkoffPayAssembly: ITinkoffPayAssembly
    private let tinkoffPayLandingAssembly: ITinkoffPayLandingAssembly
    private let cardListAssembly: ICardListAssembly
    private let cardPaymentAssembly: ICardPaymentAssembly
    private let sbpBanksAssembly: ISBPBanksAssembly
    private let uisdkConfiguration: UISDKConfiguration
    private let errorHandlerAssembly: IErrorHandlerAssembly
    private let featureToggleServiceAssembly: IFeatureToggleServiceAssembly

    // MARK: Initialization

    init(
        coreSDK: AcquiringSdk,
        paymentControllerAssembly: IPaymentControllerAssembly,
        cardsControllerAssembly: ICardsControllerAssembly,
        tinkoffPayAssembly: ITinkoffPayAssembly,
        tinkoffPayLandingAssembly: ITinkoffPayLandingAssembly,
        cardListAssembly: ICardListAssembly,
        cardPaymentAssembly: ICardPaymentAssembly,
        sbpBanksAssembly: ISBPBanksAssembly,
        errorHandlerAssembly: IErrorHandlerAssembly,
        uisdkConfiguration: UISDKConfiguration,
        featureToggleServiceAssembly: IFeatureToggleServiceAssembly
    ) {
        self.coreSDK = coreSDK
        self.paymentControllerAssembly = paymentControllerAssembly
        self.cardsControllerAssembly = cardsControllerAssembly
        self.tinkoffPayAssembly = tinkoffPayAssembly
        self.tinkoffPayLandingAssembly = tinkoffPayLandingAssembly
        self.cardListAssembly = cardListAssembly
        self.cardPaymentAssembly = cardPaymentAssembly
        self.sbpBanksAssembly = sbpBanksAssembly
        self.errorHandlerAssembly = errorHandlerAssembly
        self.uisdkConfiguration = uisdkConfiguration
        self.featureToggleServiceAssembly = featureToggleServiceAssembly
    }

    // MARK: IMainFormAssembly

    func build(
        paymentFlow: PaymentFlow,
        configuration: MainFormUIConfiguration,
        cardScannerDelegate: ICardScannerDelegate?,
        moduleCompletion: PaymentResultCompletion?
    ) -> UIViewController {
        let paymentController = paymentControllerAssembly.paymentController()
        let cardsController = paymentFlow.customerKey.map { customerKey in
            cardsControllerAssembly.cardsController(
                customerKey: customerKey,
                addCardOptions: .empty
            )
        }

        let featureToggleService = featureToggleServiceAssembly.assemble()
        let appChecker = AppChecker()

        let dataStateLoader = MainFormDataStateLoader(
            terminalService: coreSDK,
            cardsController: cardsController,
            sbpBanksService: SBPBanksService(acquiringSBPService: coreSDK),
            sbpBankAppChecker: SBPBankAppChecker(appChecker: appChecker),
            tinkoffPayAppChecker: tinkoffPayAssembly.tinkoffPayAppChecker(),
            featureToggleService: featureToggleService
        )

        let tinkoffPayController = tinkoffPayAssembly.tinkoffPayController()

        let router = MainFormRouter(
            cardListAssembly: cardListAssembly,
            cardPaymentAssembly: cardPaymentAssembly,
            sbpBanksAssembly: sbpBanksAssembly,
            tinkoffPayLandingAssembly: tinkoffPayLandingAssembly
        )

        let moneyFormatter = MoneyFormatter.shared

        let mainFormOrderDetailsViewPresenterAssembly = MainFormOrderDetailsViewPresenterAssembly(moneyFormatter: moneyFormatter)

        let validator = CardRequisitesValidator()
        let paymentSystemResolver = PaymentSystemResolver()
        let bankResolver = BankResolver()

        let savedCardViewPresenterAssembly = SavedCardViewPresenterAssembly(
            validator: validator,
            paymentSystemResolver: paymentSystemResolver,
            bankResolver: bankResolver
        )

        let switchViewPresenterAssembly = SwitchViewPresenterAssembly()
        let emailViewPresenterAssembly = EmailViewPresenterAssembly()
        let payButtonViewPresenterAssembly = PayButtonViewPresenterAssembly(moneyFormatter: moneyFormatter)
        let textAndImageHeaderViewPresenterAssembly = TextAndImageHeaderViewPresenterAssembly()

        let presenter = MainFormPresenter(
            router: router,
            mainFormOrderDetailsViewPresenterAssembly: mainFormOrderDetailsViewPresenterAssembly,
            savedCardViewPresenterAssembly: savedCardViewPresenterAssembly,
            switchViewPresenterAssembly: switchViewPresenterAssembly,
            emailViewPresenterAssembly: emailViewPresenterAssembly,
            payButtonViewPresenterAssembly: payButtonViewPresenterAssembly,
            textAndImageHeaderViewPresenterAssembly: textAndImageHeaderViewPresenterAssembly,
            dataStateLoader: dataStateLoader,
            paymentController: paymentController,
            tinkoffPayController: tinkoffPayController,
            errorHandler: errorHandlerAssembly.assemble(),
            paymentFlow: paymentFlow,
            configuration: configuration,
            shouldShowPaymentNotifications: uisdkConfiguration.showPaymentNotifications,
            cardScannerDelegate: cardScannerDelegate,
            moduleCompletion: moduleCompletion
        )

        let shouldHideLogo = !featureToggleService.featureEnabled(.mainFormLogoVisibility)
        let tableContentProvider = MainFormTableContentProvider(shouldHideLogo: shouldHideLogo)

        let view = MainFormViewController(presenter: presenter, tableContentProvider: tableContentProvider)

        router.transitionHandler = view
        presenter.view = view

        paymentController.delegate = presenter
        paymentController.webFlowDelegate = view
        tinkoffPayController.delegate = presenter

        let pullableContainerViewController = PullableContainerViewController(content: view)
        view.pullableContentDelegate = pullableContainerViewController

        return pullableContainerViewController
    }
}
