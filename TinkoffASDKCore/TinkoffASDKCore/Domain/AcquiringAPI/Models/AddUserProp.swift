//
//  AddUserProp.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 24.08.2023.
//

import Foundation

public struct AddUserProp: Encodable, Equatable {
    /// Наименование дополнительного реквизита пользователя (тег 1085)
    public let name: String
    /// Значение дополнительного реквизита пользователя (тег1086)
    public let value: String

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case value = "Value"
    }

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
    }
}
