//
//  SBPBanksAssembly.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 21.12.2022.
//

import TinkoffASDKCore
import UIKit

typealias SBPBanksModule = Module<ISBPBanksModuleInput>

final class SBPBanksAssembly: ISBPBanksAssembly {

    // Dependencies
    private let acquiringSdk: AcquiringSdk
    private let errorHandlerAssembly: IErrorHandlerAssembly
    private let configuration: UISDKConfiguration

    // MARK: - Initialization

    init(
        acquiringSdk: AcquiringSdk,
        errorHandlerAssembly: IErrorHandlerAssembly,
        configuration: UISDKConfiguration
    ) {
        self.acquiringSdk = acquiringSdk
        self.errorHandlerAssembly = errorHandlerAssembly
        self.configuration = configuration
    }

    // MARK: - ISBPBanksAssembly

    func buildPreparedModule(
        paymentSheetOutput: ISBPPaymentSheetPresenterOutput?,
        paymentFlow: PaymentFlow,
        isPresentingOverMainForm: Bool
    ) -> SBPBanksModule {
        build(
            paymentService: nil,
            paymentFlow: paymentFlow,
            output: nil,
            paymentSheetOutput: paymentSheetOutput,
            isPresentingOverMainForm: isPresentingOverMainForm,
            completion: nil
        )
    }

    func buildInitialModule(
        paymentFlow: PaymentFlow,
        isPresentingOverMainForm: Bool,
        completion: PaymentResultCompletion?
    ) -> SBPBanksModule {
        let paymentService = SBPPaymentService(
            acquiringService: acquiringSdk,
            paymentFlow: paymentFlow
        )

        return build(
            paymentService: paymentService,
            paymentFlow: paymentFlow,
            output: nil,
            paymentSheetOutput: nil,
            isPresentingOverMainForm: isPresentingOverMainForm,
            completion: completion
        )
    }

    func buildInitialModule(
        paymentFlow: PaymentFlow,
        output: ISBPBanksModuleOutput?,
        isPresentingOverMainForm: Bool,
        paymentSheetOutput: ISBPPaymentSheetPresenterOutput?
    ) -> SBPBanksModule {
        let paymentService = SBPPaymentService(
            acquiringService: acquiringSdk,
            paymentFlow: paymentFlow
        )
        return build(
            paymentService: paymentService,
            paymentFlow: paymentFlow,
            output: output,
            paymentSheetOutput: paymentSheetOutput,
            isPresentingOverMainForm: isPresentingOverMainForm,
            completion: nil
        )
    }
}

// MARK: - Private

extension SBPBanksAssembly {
    private func build(
        paymentService: SBPPaymentService?,
        paymentFlow: PaymentFlow,
        output: ISBPBanksModuleOutput?,
        paymentSheetOutput: ISBPPaymentSheetPresenterOutput?,
        isPresentingOverMainForm: Bool,
        completion: PaymentResultCompletion?
    ) -> SBPBanksModule {
        let sbpPaymentSheetAssembly = SBPPaymentSheetAssembly(
            acquiringSdk: acquiringSdk,
            errorHandlerAssembly: errorHandlerAssembly,
            configuration: configuration
        )
        let router = SBPBanksRouter(sbpBanksAssembly: self, sbpPaymentSheetAssembly: sbpPaymentSheetAssembly)

        let banksService = SBPBanksService(acquiringSBPService: acquiringSdk)
        let bankAppChecker = SBPBankAppChecker(appChecker: AppChecker())
        let bankAppOpener = assembleSBPBankOpener()
        let cellImageLoader = CellImageLoader(
            imageLoader: ImageLoader(urlDataLoader: acquiringSdk),
            imageProcessorFactory: ImageProcessorFactory()
        )
        cellImageLoader.set(type: .roundAndSize(.logoImageSize))
        let cellPresentersAssembly = SBPBankCellPresenterAssembly(cellImageLoader: cellImageLoader)

        let presenter = SBPBanksPresenter(
            router: router,
            output: output,
            paymentSheetOutput: paymentSheetOutput,
            moduleCompletion: completion,
            paymentService: paymentService,
            banksService: banksService,
            bankAppChecker: bankAppChecker,
            bankAppOpener: bankAppOpener,
            cellPresentersAssembly: cellPresentersAssembly,
            dispatchGroup: DispatchGroup(),
            mainDispatchQueue: DispatchQueue.main,
            errorHandler: errorHandlerAssembly.assemble(),
            paymentFlow: paymentFlow,
            shouldShowPaymentNotifications: configuration.showPaymentNotifications,
            isPresentingOverMainForm: isPresentingOverMainForm
        )

        let view = SBPBanksViewController(presenter: presenter)
        presenter.view = view
        router.transitionHandler = view
        return Module(view: view, input: presenter)
    }

    private func assembleSBPBankOpener() -> ISBPBankAppOpener {
        if UITestsUtils.hasConfigKey(UiTestsConfigKeys.sbpBanksAreInstalled) {
            return UiTestsSBPBankAppOpener()
        }

        return SBPBankAppOpener(application: UIApplication.shared)
    }
}

// MARK: - Constants

private extension CGSize {
    static let logoImageSize = CGSize(width: 40, height: 40)
}
