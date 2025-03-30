//
//  ValueForDataProvider.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 29.07.2024.
//

import Foundation

/// Формирует данные для последующей отправки их поле `DATA`
protocol IValueForDataProvider {

    /// FinishAuthorize
    /// - Returns: список тоглов / nil если список пуст
    func formTogglesDataForFinishAuthorize(tdsVersion: ThreeDSVersion?) -> [String: String]?

    /// AttachCard
    func formTogglesDataForAttachCard(tdsVersion: ThreeDSVersion?) -> [String: String]?
}

final class ValueForDataProvider: IValueForDataProvider {

    private let togglesService: IInternalFeatureToggleService
    private let cacheService: IAcquiringCacheService
    private let vendorIdentifierProvider: IStringProvider

    init(
        togglesService: IInternalFeatureToggleService,
        cacheService: IAcquiringCacheService,
        vendorIdentifierProvider: IStringProvider
    ) {
        self.togglesService = togglesService
        self.cacheService = cacheService
        self.vendorIdentifierProvider = vendorIdentifierProvider
    }

    func formTogglesDataForFinishAuthorize(tdsVersion: ThreeDSVersion?) -> [String: String]? {
        var result: [String: String] = [:]
        lazy var cache = cacheService.getTogglesCache()
        lazy var overridenToggles = togglesService.overridenToggles()

        let appBasedToggle = togglesService.toggles.first { $0.id == FeatureToggleList.appBased.value.id }
        guard let toggle = appBasedToggle else { return nil }

        // qa overriden toggle
        if let overridenTogglePair = overridenToggles.first(where: { $0.key == toggle.id }) {
            result[toggle.id] = "qa_overriden:\(overridenTogglePair.value)" + String.tdsVersionString(tdsVersion: tdsVersion)
        } else if let cachedValue = cache?.first(where: { $0.path == toggle.id }) {
            // remote/cached toggle
            result[toggle.id] = formJsonDictionarry(cachedToggle: cachedValue, tdsVersion: tdsVersion)
        } else {
            // local toggle value
            var stringValue = "default:\(toggle.isEnabled)"
            stringValue += ", \(GetTogglesRequest.deviceId):\(vendorIdentifierProvider.value)"
            stringValue += .tdsVersionString(tdsVersion: tdsVersion)
            result[toggle.id] = stringValue
        }
        return result.isEmpty ? nil : result
    }

    func formTogglesDataForAttachCard(tdsVersion: ThreeDSVersion?) -> [String: String]? {
        formTogglesDataForFinishAuthorize(tdsVersion: tdsVersion)
    }

    private func formJsonDictionarry(cachedToggle: ToggleModel, tdsVersion: ThreeDSVersion?) -> String? {
        // remote/cached toggles
        var jsonDictionary: [String: String] = [
            ToggleModel.CodingKeys.dcoAppliedStatus.stringValue: cachedToggle.status.rawValue,
            ToggleModel.CodingKeys.value.stringValue: String(cachedToggle.value),
            GetTogglesRequest.deviceId: vendorIdentifierProvider.value,
        ]
        if let tdsVersion {
            jsonDictionary[.tdsKey] = String.tdsVersionValue(tdsVersion: tdsVersion)
        } else {
            jsonDictionary[.tdsKey] = String.no
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

private extension String {

    static let tdsKey = "3DS"
    static let no = "NO"

    static func tdsVersionValue(tdsVersion: ThreeDSVersion) -> String {
        switch tdsVersion {
        case .appBased: return "2.0 app"
        case .v2: return "2.0 brw"
        case .v1: return "1.0"
        }
    }

    static func tdsVersionString(tdsVersion: ThreeDSVersion?) -> String {
        guard let tdsVersion else { return ", \(tdsKey): \(String.no)" }
        return ", \(tdsKey): \(tdsVersionValue(tdsVersion: tdsVersion))"
    }
}
