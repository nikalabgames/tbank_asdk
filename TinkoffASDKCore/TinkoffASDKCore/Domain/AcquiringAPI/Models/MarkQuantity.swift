//
//  MarkQuantity.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 23.08.2023.
//

import Foundation

public struct MarkQuantity: Encodable, Equatable {
    public let numerator: Int?
    public let denominator: Int?

    private enum CodingKeys: String, CodingKey {
        case numerator = "Numerator"
        case denominator = "Denominator"
    }

    public init(numerator: Int?, denominator: Int?) {
        self.numerator = numerator
        self.denominator = denominator
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(numerator, forKey: .numerator)
        try container.encodeIfPresent(denominator, forKey: .denominator)
    }
}
