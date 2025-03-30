//
//  OperatingСheckProps.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 24.08.2023.
//

import Foundation

public struct OperatingCheckProps: Encodable, Equatable {
    /// Идентификатор операции (тег 1271)
    public let name: String
    /// Данные операции (тег 1272)
    public let value: String
    /// Дата и время операции в формате ДД.ММ.ГГГГ ЧЧ:ММ:СС (тег 1273)
    public let timestamp: String

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case value = "Value"
        case timestamp = "Timestamp"
    }

    public init(name: String, value: String, timestamp: String) {
        self.name = name
        self.value = value
        self.timestamp = timestamp
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
