//
//
//  GetSBPBanksPayload.swift
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

public struct GetSBPBanksPayload: Decodable {
    private enum CodingKeys: String, CodingKey {
        case banks = "dictionary"
    }

    public let banks: [SBPBank]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var banksArray = try container.nestedUnkeyedContainer(forKey: .banks)
        var resultBanks = [SBPBank]()
        while !banksArray.isAtEnd {
            guard let bank = try? banksArray.decode(SBPBank.self) else {
                continue
            }
            resultBanks.append(bank)
        }
        banks = resultBanks
    }

    public init(banks: [SBPBank]) {
        self.banks = banks
    }
}
