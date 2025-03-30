//
//  PaymentCardCheckType.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 07.10.2022.
//

import Foundation

public enum PaymentCardCheckType: Encodable, Equatable, RawRepresentable {
    /// Проверка не требуется
    case no
    /// Проверка через 3DS
    case check3DS
    /// Списание рубля и его возвращение
    case hold
    /// Если карта поддерживает 3DS то проверяем через него, в противном случае идем по hold
    case hold3DS
    /// Кастомный вариант
    case custom(string: String)

    public var rawValue: String {
        switch self {
        case .no: return "NO"
        case .check3DS: return "3DS"
        case .hold: return "HOLD"
        case .hold3DS: return "3DSHOLD"
        case let .custom(string): return string
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case Self.no.rawValue: self = .no
        case Self.check3DS.rawValue: self = .check3DS
        case Self.hold.rawValue: self = .hold
        case Self.hold3DS.rawValue: self = .hold3DS
        default: self = .custom(string: rawValue)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var singleValueContainer = encoder.singleValueContainer()
        try singleValueContainer.encode(rawValue)
    }
}
