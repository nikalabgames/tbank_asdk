//
//
//  ChargePayload.swift
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

public struct ChargePayload: Decodable {
    public let status: AcquiringStatus
    public let paymentState: GetPaymentStatePayload

    public init(
        status: AcquiringStatus,
        paymentState: GetPaymentStatePayload
    ) {
        self.status = status
        self.paymentState = paymentState
    }

    public init(from decoder: Decoder) throws {
        paymentState = try GetPaymentStatePayload(from: decoder)
        status = paymentState.status
    }
}
