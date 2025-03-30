//
//  EnvironmentParametersProvider.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 11.12.2022.
//

import Foundation

protocol IEnvironmentParametersProvider {
    var environmentParameters: [String: String] { get }
}

final class EnvironmentParametersProvider {
    // MARK: Dependencies

    private let deviceInfoProvider: IDeviceInfoProvider
    private let asdkVersionProvider: IAsdkVersionProvider
    private let language: AcquiringSdkLanguage?

    // MARK: Init

    init(
        deviceInfoProvider: IDeviceInfoProvider,
        asdkVersionProvider: IAsdkVersionProvider,
        language: AcquiringSdkLanguage?
    ) {
        self.deviceInfoProvider = deviceInfoProvider
        self.asdkVersionProvider = asdkVersionProvider
        self.language = language
    }
}

// MARK: - IEnvironmentParametersProvider

extension EnvironmentParametersProvider: IEnvironmentParametersProvider {
    var environmentParameters: [String: String] {
        let parameters: [String: String] = [
            .connectionType: .mobileSDK,
            .version: asdkVersionProvider.formVersionString(),
            .softwareVersion: deviceInfoProvider.systemVersion,
            .deviceModel: deviceInfoProvider.modelVersion,
            .device: .sdk,
            .deviceOs: .ios,
            Constants.Keys.language: language?.rawValue,
        ].compactMapValues { $0 }

        return parameters
    }
}

// MARK: - Constants

private extension String {
    static let mobileSDK = "mobile_sdk"
    static let sdk = "SDK"
    static let connectionType = "connection_type"
    static let version = "sdk_version"
    static let softwareVersion = "software_version"
    static let deviceModel = "device_model"
    static let device = "Device"
    static let deviceOs = "DeviceOs"
    static let ios = "iOS"
}
