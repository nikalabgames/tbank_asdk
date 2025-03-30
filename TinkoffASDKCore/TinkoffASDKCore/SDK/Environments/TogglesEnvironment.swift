//
//  TogglesEnvironment.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 15.07.2024.
//

import Foundation

/// Окружение для запросов к сервису тоглов
enum TogglesEnvironment: String {
    case test = "https://cfg-stage.dev-tcsgroup.io"
    case prod = "https://cfg.tbank.ru"

    init(sdkEnv: AcquiringSdkEnvironment) {
        switch sdkEnv {
        case .test:
            self = .test
        default:
            self = .prod
        }
    }
}
