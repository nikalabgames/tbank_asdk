//
//  GetTogglesPayload.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 15.07.2024.
//

import Foundation

public struct GetTogglesPayload: Decodable {

    public let items: [ToggleModel]

    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        let optionalItems = try responseContainer.decode([SafeDecodable<ToggleModel>].self, forKey: .items)
        items = optionalItems.compactMap { $0.decodedValue }
    }

    internal init(items: [ToggleModel]) {
        self.items = items
    }

    enum CodingKeys: String, CodingKey {
        case response
        case items
    }
}

public struct ToggleModel: Codable, Hashable {
    /// Значение тогла - вкл/выкл
    public let value: Bool
    /// Путь тогла
    public let path: String
    /// Статус персонализации тогла
    public let status: ToggleDcoStatus

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(Bool.self, forKey: .value)
        path = try container.decode(String.self, forKey: .path)
        let dcoContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .dco)
        status = try dcoContainer.decode(ToggleDcoStatus.self, forKey: .dcoAppliedStatus)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(path, forKey: .path)
        var dcoContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .dco)
        try dcoContainer.encode(status, forKey: .dcoAppliedStatus)
    }

    internal init(value: Bool, path: String, status: ToggleDcoStatus) {
        self.value = value
        self.path = path
        self.status = status
    }

    /// Вернет название тогла
    public func name() -> String {
        guard let url = URL(string: path) else { return "" }
        return url.lastPathComponent
    }

    enum CodingKeys: CodingKey {
        case value
        case path
        case dco
        case dcoAppliedStatus
    }
}

public enum ToggleDcoStatus: String, Codable {
    case applied
    case notMatch = "not_match"
    case noPlacement = "no_placement"
    case notPersonalizable = "not_personalizable"

    case skipped
    case failure

    public var isValid: Bool {
        switch self {
        case .failure, .skipped:
            return false
        default:
            return true
        }
    }
}
