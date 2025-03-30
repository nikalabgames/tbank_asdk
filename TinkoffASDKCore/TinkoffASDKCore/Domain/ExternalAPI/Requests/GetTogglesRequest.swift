//
//  GetTogglesRequest.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 15.07.2024.
//

import Foundation

struct GetTogglesRequest: NetworkRequest {
    let baseURL: URL
    let path: String = "api-gateway/v2/getToggles"
    let parameters: HTTPParameters
    let httpMethod: HTTPMethod = .post

    let terminalKey: String
    let asdkVersion: String
    let userIdentifierForVendor: String

    init(
        baseURL: URL,
        terminalKey: String,
        asdkVersion: String,
        userIdentifierForVendor: String,
        merchAppVersion: String?
    ) {
        self.baseURL = baseURL
        self.terminalKey = terminalKey
        self.asdkVersion = asdkVersion
        self.userIdentifierForVendor = userIdentifierForVendor

        parameters = [
            .path: Self.asdkPath,
            .service: String.asdk,
            .userIds: [Self.deviceId: userIdentifierForVendor],
            .context: [
                String.asdkVersion: asdkVersion,
                String.terminalKey: terminalKey,
                String.platform: .ios,
                String.merchAppVersion: merchAppVersion,
            ],
        ]
    }

    static let asdkPath = "asdk/iOS"
    static let deviceId = "deviceId"
}

private extension String {
    static let path = "path"
    static let service = "service"
    static let userIds = "userIds"
    static let context = "context"
    static let asdk = "asdk"
    static let asdkVersion = "asdk_version"
    static let platform = "platform"
    static let ios = "iOS"
    static let terminalKey = "terminalKey"
    static let merchAppVersion = "merch_app_version"
}
