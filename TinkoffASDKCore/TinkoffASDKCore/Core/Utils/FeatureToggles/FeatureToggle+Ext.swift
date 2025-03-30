//
//  FeatureToggle+Ext.swift
//  TinkoffASDKCore
//
//  Created by Sergey Galagan on 09.09.2024.
//

import Foundation

extension FeatureToggle {
    static let appBased = FeatureToggle(
        description: "App based 3-ds",
        id: baseId + "app_based_flow",
        isEnabled: false
    )

    static let mainFormLogoVisibility = FeatureToggle(
        description: "Mainform logo visibility",
        id: baseId + "visibility/logo",
        isEnabled: true
    )

    static let tpayMethodVisibility = FeatureToggle(
        description: "Payment form tpay method visibility",
        id: baseId + "visibility/tpay",
        isEnabled: true
    )

    static let sbpMethodVisibility = FeatureToggle(
        description: "Payment form sbp method visibility",
        id: baseId + "visibility/sbp",
        isEnabled: true
    )

    private static let baseId = GetTogglesRequest.asdkPath + "/"
}
