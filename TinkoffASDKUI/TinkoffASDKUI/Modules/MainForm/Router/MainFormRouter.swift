//
//  MainFormRouter.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 19.01.2023.
//

import TinkoffASDKCore
import UIKit

final class MainFormRouter: IMainFormRouter {
    // MARK: Dependencies

    weak var transitionHandler: UIViewController?
    private let cardListAssembly: ICardListAssembly
    private let cardPaymentAssembly: ICardPaymentAssembly
    private let sbpBanksAssembly: ISBPBanksAssembly
    private let tinkoffPayLandingAssembly: ITinkoffPayLandingAssembly

    // MARK: Init

    init(
        cardListAssembly: ICardListAssembly,
        cardPaymentAssembly: ICardPaymentAssembly,
        sbpBanksAssembly: ISBPBanksAssembly,
        tinkoffPayLandingAssembly: ITinkoffPayLandingAssembly
    ) {
        self.cardListAssembly = cardListAssembly
        self.cardPaymentAssembly = cardPaymentAssembly
        self.sbpBanksAssembly = sbpBanksAssembly
        self.tinkoffPayLandingAssembly = tinkoffPayLandingAssembly
    }

    // MARK: IMainFormRouter

    func openCardPaymentList(
        paymentFlow: PaymentFlow,
        cards: [PaymentCard],
        selectedCard: PaymentCard,
        cardListOutput: ICardListPresenterOutput?,
        cardPaymentOutput: ICardPaymentPresenterModuleOutput?,
        cardScannerDelegate: ICardScannerDelegate?
    ) {
        guard let customerKey = paymentFlow.customerOptions?.customerKey else { return }

        let cardPaymentList = cardListAssembly.cardPaymentList(
            customerKey: customerKey,
            cards: cards,
            selectedCard: selectedCard,
            paymentFlow: paymentFlow,
            amount: paymentFlow.amount,
            output: cardListOutput,
            cardPaymentOutput: cardPaymentOutput,
            cardScannerDelegate: cardScannerDelegate,
            completion: nil
        )

        let navigationController = UINavigationController.withElevationBar(rootViewController: cardPaymentList)

        transitionHandler?.present(navigationController, animated: true)
    }

    func openCardPayment(
        paymentFlow: PaymentFlow,
        cards: [PaymentCard]?,
        output: ICardPaymentPresenterModuleOutput?,
        cardListOutput: ICardListPresenterOutput?,
        cardScannerDelegate: ICardScannerDelegate?
    ) {
        let cardPaymentViewController = cardPaymentAssembly.anyCardPayment(
            activeCards: cards,
            paymentFlow: paymentFlow,
            amount: paymentFlow.amount,
            output: output,
            cardListOutput: cardListOutput,
            cardScannerDelegate: cardScannerDelegate
        )

        let navVC = UINavigationController.withElevationBar(rootViewController: cardPaymentViewController)
        transitionHandler?.present(navVC, animated: true)
    }

    func openSBP(
        paymentFlow: PaymentFlow,
        banks: [SBPBank]?,
        output: ISBPBanksModuleOutput?,
        paymentSheetOutput: ISBPPaymentSheetPresenterOutput?
    ) {
        let sbpModule = sbpBanksAssembly.buildInitialModule(
            paymentFlow: paymentFlow,
            output: output,
            isPresentingOverMainForm: true,
            paymentSheetOutput: paymentSheetOutput
        )
        sbpModule.input.set(banks: banks)

        let navVC = UINavigationController.withElevationBar(rootViewController: sbpModule.view)
        transitionHandler?.present(navVC, animated: true)
    }

    func openTinkoffPayLanding(completion: VoidBlock?) {
        let navigationController = tinkoffPayLandingAssembly.landingNavigationController()
        transitionHandler?.present(navigationController, animated: true, completion: completion)
    }
}
