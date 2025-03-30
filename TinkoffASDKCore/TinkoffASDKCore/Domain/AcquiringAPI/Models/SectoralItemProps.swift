//
//  SectoralItemProps.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 23.08.2023.
//

import Foundation

public struct SectoralItemProps: Encodable, Equatable {
    /// Идентификатор ФОИВ (федеральный орган исполнительной власти).
    public let federalId: String
    /// Дата нормативного акта ФОИВ
    public let date: String
    /// Номер нормативного акта ФОИВ
    public let number: String
    /// Состав значений, определенных нормативным актом ФОИВ.
    public let value: String

    private enum CodingKeys: String, CodingKey {
        case federalId = "FederalId"
        case date = "Date"
        case number = "Number"
        case value = "Value"
    }

    public init(federalId: String, date: String, number: String, value: String) {
        self.federalId = federalId
        self.date = date
        self.number = number
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(federalId, forKey: .federalId)
        try container.encode(date, forKey: .date)
        try container.encode(number, forKey: .number)
        try container.encode(value, forKey: .value)
    }
}
