//
//
//  APIFailureError.swift
//
//  Copyright (c) 2021 Tinkoff Bank
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

public struct APIFailureError: LocalizedError, Decodable, CustomNSError {
    private enum CodingKeys: CodingKey {
        case errorCode
        case errorMessage
        case errorDetails
        case terminalKey
        case status
        case orderId
        case paymentId
        case amount

        var stringValue: String {
            switch self {
            case .errorCode: return Constants.Keys.errorCode
            case .errorDetails: return Constants.Keys.errorDetails
            case .errorMessage: return Constants.Keys.errorMessage
            case .terminalKey: return Constants.Keys.terminalKey
            case .status: return Constants.Keys.status
            case .orderId: return Constants.Keys.orderId
            case .paymentId: return Constants.Keys.paymentId
            case .amount: return Constants.Keys.amount
            }
        }
    }

    public let errorCode: Int
    public let errorMessage: String?
    public let errorDetails: String?
    public let terminalKey: String?
    public let status: String?
    public let orderId: String?
    public let paymentId: String?
    public let amount: Int?

    // MARK: - CustomNSError

    public var errorUserInfo: [String: Any] {
        guard let errorDescription = errorDescription else {
            return [:]
        }
        return [NSLocalizedDescriptionKey: errorDescription]
    }

    // MARK: - LocalizedError

    public var errorDescription: String? {
        var errorDescription = Loc.APIError.failureError
        if errorMessage != nil || errorDetails != nil { errorDescription += ": " }
        if let errorMessage = errorMessage {
            errorDescription += errorMessage
            if errorDetails != nil { errorDescription += " - " }
        }
        if let errorDetails = errorDetails {
            errorDescription += errorDetails
        }
        return errorDescription
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let errorCodeString = try container.decode(String.self, forKey: .errorCode)
        errorCode = Int(errorCodeString) ?? 0
        errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
        errorDetails = try container.decodeIfPresent(String.self, forKey: .errorDetails)
        terminalKey = try container.decodeIfPresent(String.self, forKey: .terminalKey)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        orderId = try container.decodeIfPresent(String.self, forKey: .orderId)
        paymentId = try container.decodeIfPresent(String.self, forKey: .paymentId)
        amount = try container.decodeIfPresent(Int.self, forKey: .amount)
    }

    // MARK: - Init

    internal init(
        errorCode: Int,
        errorMessage: String? = nil,
        errorDetails: String? = nil,
        terminalKey: String? = nil,
        status: String? = nil,
        orderId: String? = nil,
        paymentId: String? = nil,
        amount: Int? = nil
    ) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.errorDetails = errorDetails
        self.terminalKey = terminalKey
        self.status = status
        self.orderId = orderId
        self.paymentId = paymentId
        self.amount = amount
    }
}
