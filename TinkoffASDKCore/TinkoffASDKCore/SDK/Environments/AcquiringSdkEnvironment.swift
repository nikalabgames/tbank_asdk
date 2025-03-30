//
//  AcquiringSdkEnvironment.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 15.07.2024.
//

import Foundation

public enum AcquiringSdkEnvironment: Equatable, Codable, CustomStringConvertible, RawRepresentable {
    case test
    case preProd
    case prod
    case custom(String)

    public var rawValue: String {
        switch self {
        case .test: return "rest-api-test.tinkoff.ru"
        case .preProd: return "qa-mapi.tcsbank.ru"
        case .prod: return "securepay.tinkoff.ru"
        case let .custom(address): return address
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "rest-api-test.tinkoff.ru": self = .test
        case "qa-mapi.tcsbank.ru": self = .preProd
        case "securepay.tinkoff.ru": self = .prod
        default: self = .custom(rawValue)
        }
    }

    public var description: String {
        switch self {
        case .test: return "test"
        case .preProd: return "preProd"
        case .prod: return "prod"
        case .custom: return "custom"
        }
    }
}