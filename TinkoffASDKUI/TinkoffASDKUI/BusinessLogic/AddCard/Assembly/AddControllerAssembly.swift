//
//  AddControllerAssembly.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 19.02.2023.
//

import Foundation
import TinkoffASDKCore

final class AddCardControllerAssembly: IAddCardControllerAssembly {
    // MARK: Dependencies

    private let coreSDK: AcquiringSdk
    private let webFlowControllerAssembly: IThreeDSWebFlowControllerAssembly
    private let appBasedFlowControllerAssembly: ITDSControllerAssembly
    private let featureToggleServiceAssembly: IFeatureToggleServiceAssembly
    private let configuration: UISDKConfiguration

    // MARK: Init

    init(
        coreSDK: AcquiringSdk,
        webFlowControllerAssembly: IThreeDSWebFlowControllerAssembly,
        appBasedFlowControllerAssembly: ITDSControllerAssembly,
        featureToggleServiceAssembly: IFeatureToggleServiceAssembly,
        configuration: UISDKConfiguration
    ) {
        self.coreSDK = coreSDK
        self.webFlowControllerAssembly = webFlowControllerAssembly
        self.appBasedFlowControllerAssembly = appBasedFlowControllerAssembly
        self.featureToggleServiceAssembly = featureToggleServiceAssembly
        self.configuration = configuration
    }

    // MARK: IAddCardControllerAssembly

    func addCardController(
        customerKey: String,
        addCardOptions: AddCardOptions
    ) -> IAddCardController {
        return AddCardController(
            addCardService: coreSDK,
            threeDSDeviceInfoProvider: coreSDK.threeDSDeviceInfoProvider(),
            webFlowController: webFlowControllerAssembly.threeDSWebFlowController(),
            threeDSService: coreSDK,
            customerKey: customerKey,
            addCardOptions: addCardOptions,
            checkType: configuration.addCardCheckType,
            tdsController: appBasedFlowControllerAssembly.assemble(),
            featureToggleService: featureToggleServiceAssembly.assemble()
        )
    }
}
