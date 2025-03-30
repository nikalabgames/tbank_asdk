//
//  sectoralCheckProps.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 24.08.2023.
//

import Foundation

public struct SectoralCheckProps: Encodable, Equatable {
    /// Идентификатор ФОИВ (тег 1262). Максимальное количество символов – 3
    public let federalId: String
    /// Дата документа основания в формате ДД.ММ.ГГГГ (тег 1263)
    public let date: String
    /// Номер документа основания (тег 1264)
    public let number: String
    /// Значение отраслевого реквизита (тег 1265)
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
