//
//
//  URLProvider.swift
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

protocol IURLProvider {
    var url: URL { get }
}

struct URLProvider: IURLProvider {
    let url: URL

    // MARK: Init

    init?(host: String) {
        let urlString = (host.hasPrefix("http://") || host.hasPrefix("https://")) ? host : "https://\(host)"

        guard let url = URL(string: urlString) else {
            return nil
        }

        self.url = url
    }
}
