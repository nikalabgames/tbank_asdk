//
//  ConfigSdkEnvironment.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 15.07.2024.
//

import Foundation

enum ConfigSdkEnvironment: String {
    case test = "asdk-config-test.cdn-tinkoff.ru"
    case prod = "asdk-config-prod.cdn-tinkoff.ru"

    init(sdkEnv: AcquiringSdkEnvironment) {
        switch sdkEnv {
        case .test:
            self = .test
        default:
            self = .prod
        }
    }
}
