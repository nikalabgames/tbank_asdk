//
//
//  RemoveCardPayload.swift
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

public struct RemoveCardPayload: Decodable, Equatable {
    private enum CodingKeys: CodingKey {
        case cardId
        case cardStatus

        var stringValue: String {
            switch self {
            case .cardId: return Constants.Keys.cardId
            case .cardStatus: return Constants.Keys.status
            }
        }
    }

    public let cardId: String
    public let cardStatus: PaymentCardStatus

    public init(cardId: String, cardStatus: PaymentCardStatus) {
        self.cardId = cardId
        self.cardStatus = cardStatus
    }
}
