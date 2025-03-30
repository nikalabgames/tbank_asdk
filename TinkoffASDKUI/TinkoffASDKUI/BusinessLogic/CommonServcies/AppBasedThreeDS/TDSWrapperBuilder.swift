//
//
//  TDSWrapperBuilder.swift
//
//  Copyright (c) 2021 Tinkoff Bank
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import ThreeDSWrapper
import TinkoffASDKCore
import UIKit

protocol ITDSWrapperBuilder {
    func build() -> ITDSWrapper
}

final class TDSWrapperBuilder: ITDSWrapperBuilder {

    private let env: AcquiringSdkEnvironment
    private let language: AcquiringSdkLanguage?
    private let tdsCustomizationBuilder: ITDSCustomizationBuilder

    init(
        env: AcquiringSdkEnvironment,
        language: AcquiringSdkLanguage?,
        tdsCustomizationBuilder: ITDSCustomizationBuilder
    ) {
        self.env = env
        self.language = language
        self.tdsCustomizationBuilder = tdsCustomizationBuilder
    }

    func build() -> ITDSWrapper {
        let locale: Locale

        switch language {
        case .ru:
            locale = Locale(identifier: .russian)
        case .en:
            locale = Locale(identifier: .english)
        default:
            locale = Locale(identifier: .russian)
        }

        let sdkConfiguration = TDSWrapper.SDKConfiguration(
            uiCustomization: buildUICustomization(),
            uiCustomizationConstraints: nil,
            locale: locale,
            spinnerProducer: TDSSpinnerProducer()
        )

        let environment: ThreeDSWrapper.TDSWrapper.Environment = {
            switch env {
            case .prod, .custom: return .production
            case .preProd: return .production
            case .test: return .test
            }
        }()

        return TDSWrapper(
            sdkConfiguration: sdkConfiguration,
            wrapperConfiguration: TDSWrapper.WrapperConfiguration(environment: environment)
        )
    }

    private func buildUICustomization() -> ThreeDSWrapper.UiCustomization {
        return tdsCustomizationBuilder.build()
    }
}

// MARK: - Locale identifiers

private extension String {
    static let russian = "ru_RU"
    static let english = "en_US"
}
