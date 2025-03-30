//
//
//  Checking3DSURLData.swift
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

public struct Checking3DSURLData: Equatable {
    public var tdsServerTransID: String
    public var threeDSMethodURL: String
    public var notificationURL: String

    public init(tdsServerTransID: String, threeDSMethodURL: String, notificationURL: String) {
        self.tdsServerTransID = tdsServerTransID
        self.threeDSMethodURL = threeDSMethodURL
        self.notificationURL = notificationURL
    }
}
