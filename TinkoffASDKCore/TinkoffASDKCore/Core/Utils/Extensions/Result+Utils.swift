//
//
//  Result+Utils.swift
//
//  Copyright (c) 2022 Tinkoff Bank
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

extension Result {
    func tryMap<T>(_ transform: (Success) throws -> T) -> Result<T, Error> {
        switch self {
        case let .success(success):
            do {
                return .success(try transform(success))
            } catch {
                return .failure(error)
            }
        case let .failure(failure):
            return .failure(failure)
        }
    }
}
