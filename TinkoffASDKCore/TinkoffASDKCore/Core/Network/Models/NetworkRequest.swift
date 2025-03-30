//
//
//  NetworkRequest.swift
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

typealias HTTPParameters = [String: Any]
typealias HTTPHeaders = [String: String]

struct HTTPMethod: RawRepresentable, Hashable {
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")

    let rawValue: String
}

extension HTTPMethod {
    var isAllowedToContainBody: Bool {
        self == .post
    }

    var isAllowedToContainQuery: Bool {
        self == .get
    }
}

enum ParametersEncoding {
    case json
    case urlEncodedForm
}

protocol NetworkRequest {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: HTTPParameters { get }
    var parametersEncoding: ParametersEncoding { get }

    /// Используется только в `GET` запросах для формирования `query` строки
    /// Добавляется в конце `url` ссылки после `path`
    var queryItems: [URLQueryItem] { get }
}

/// При добавлении новых значений не забудь проставить их в `AdaptedRequest` структуре
extension NetworkRequest {
    var parameters: HTTPParameters { [:] }
    var headers: HTTPHeaders { [:] }
    var parametersEncoding: ParametersEncoding { .json }
    var queryItems: [URLQueryItem] { [] }
}
