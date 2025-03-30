//
//  ExternalRequestBuilder.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 06.10.2022.
//

import Foundation

protocol IExternalRequestBuilder {
    func get3DSAppBasedConfigRequest() -> NetworkRequest
    func getSBPBanks() -> NetworkRequest
    func getToggles() -> NetworkRequest
}

final class ExternalRequestBuilder: IExternalRequestBuilder {
    private let appBasedConfigURLProvider: IURLProvider
    private let togglesURLProvider: IURLProvider
    private let terminalKeyProvider: IStringProvider
    private let vendorIdentifierProvider: IStringProvider
    private let asdkVersionProvider: IAsdkVersionProvider
    private let appVersionProvider: IStringProvider?

    init(
        appBasedConfigURLProvider: IURLProvider,
        togglesURLProvider: IURLProvider,
        terminalKeyProvider: IStringProvider,
        vendorIdentifierProvider: IStringProvider,
        asdkVersionProvider: IAsdkVersionProvider,
        appVersionProvider: IStringProvider?
    ) {
        self.appBasedConfigURLProvider = appBasedConfigURLProvider
        self.togglesURLProvider = togglesURLProvider
        self.terminalKeyProvider = terminalKeyProvider
        self.vendorIdentifierProvider = vendorIdentifierProvider
        self.asdkVersionProvider = asdkVersionProvider
        self.appVersionProvider = appVersionProvider
    }

    func get3DSAppBasedConfigRequest() -> NetworkRequest {
        Get3DSAppBasedCertsConfigRequest(baseURL: appBasedConfigURLProvider.url)
    }

    func getSBPBanks() -> NetworkRequest {
        GetSBPBanksRequest()
    }

    func getToggles() -> NetworkRequest {
        GetTogglesRequest(
            baseURL: togglesURLProvider.url,
            terminalKey: terminalKeyProvider.value,
            asdkVersion: asdkVersionProvider.formVersionString(),
            userIdentifierForVendor: vendorIdentifierProvider.value,
            merchAppVersion: appVersionProvider?.value
        )
    }
}
