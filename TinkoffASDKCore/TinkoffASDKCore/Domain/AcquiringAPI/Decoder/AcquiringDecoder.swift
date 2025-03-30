//
//
//  AcquiringDecoder.swift
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

protocol IAcquiringDecoder {
    func decode<Payload: Decodable>(
        _ type: Payload.Type,
        from data: Data,
        with strategy: AcquiringDecodingStrategy
    ) throws -> Payload
}

final class AcquiringDecoder: IAcquiringDecoder {
    private let decoder = JSONDecoder()

    // MARK: IAcquiringDecoder

    func decode<Payload: Decodable>(
        _ type: Payload.Type,
        from data: Data,
        with strategy: AcquiringDecodingStrategy
    ) throws -> Payload {
        let apiResponse: APIResponse<Payload>

        do {
            switch strategy {
            case .standard:
                apiResponse = try decodeStandard(data: data)
            case .clipped:
                apiResponse = try decodeClipped(data: data)
            }
        } catch {
            throw APIError.invalidResponse
        }

        return try apiResponse
            .result
            .mapError { APIError.failure($0) }
            .get()
    }

    // MARK: Helpers

    private func decodeStandard<Payload: Decodable>(data: Data) throws -> APIResponse<Payload> {
        return try decoder.decode(APIResponse<Payload>.self, from: data)
    }

    private func decodeClipped<Payload: Decodable>(data: Data) throws -> APIResponse<Payload> {
        do {
            let error = try? decoder.decode(APIFailureError.self, from: data)

            if let error = error, error.errorCode != 0 {
                return APIResponse(
                    success: false,
                    errorCode: error.errorCode,
                    terminalKey: nil,
                    result: .failure(error)
                )
            } else {
                let payload = try decoder.decode(Payload.self, from: data)
                return APIResponse(
                    success: true,
                    errorCode: 0,
                    terminalKey: nil,
                    result: .success(payload)
                )
            }
        } catch {
            return try decodeStandard(data: data)
        }
    }
}
