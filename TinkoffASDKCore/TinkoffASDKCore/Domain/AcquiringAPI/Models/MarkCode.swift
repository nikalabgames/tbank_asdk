//
//  MarkCode.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 23.08.2023.
//

import Foundation

public struct MarkCode: Encodable, Equatable {
    public let markCodeType: String
    public let value: String

    private enum CodingKeys: String, CodingKey {
        case markCodeType = "MarkCodeType"
        case value = "Value"
    }

    public init(markCodeType: String, value: String) {
        self.markCodeType = markCodeType
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(markCodeType, forKey: .markCodeType)
        try container.encode(value, forKey: .value)
    }
}
