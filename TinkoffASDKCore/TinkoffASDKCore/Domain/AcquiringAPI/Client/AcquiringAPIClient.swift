//
//
//  AcquiringAPIClient.swift
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

protocol IAcquiringAPIClient {
    func performRequest<Payload: Decodable>(
        _ request: AcquiringRequest,
        completion: @escaping (Result<Payload, Error>) -> Void
    ) -> Cancellable
}

final class AcquiringAPIClient: IAcquiringAPIClient {
    // MARK: Adaptation Response

    private struct ResponseBatch {
        let adaptedRequest: AcquiringRequest
        let networkResponse: NetworkResponse
    }

    // MARK: Dependencies

    private let requestAdapter: IAcquiringRequestAdapter
    private let networkClient: INetworkClient
    private let decoder: IAcquiringDecoder

    // MARK: Init

    init(
        requestAdapter: IAcquiringRequestAdapter,
        networkClient: INetworkClient,
        decoder: IAcquiringDecoder
    ) {
        self.requestAdapter = requestAdapter
        self.networkClient = networkClient
        self.decoder = decoder
    }

    // MARK: IAcquiringAPIClient

    func performRequest<Payload: Decodable>(
        _ request: AcquiringRequest,
        completion: @escaping (Result<Payload, Error>) -> Void
    ) -> Cancellable {
        performAdapting(request: request) { [decoder] networkResult in
            let result: Result<Payload, Error> = networkResult.tryMap { response in
                try decoder.decode(
                    Payload.self,
                    from: response.networkResponse.data,
                    with: response.adaptedRequest.decodingStrategy
                )
            }

            completion(result)
        }
    }

    // MARK: Helpers

    private func performAdapting(
        request: AcquiringRequest,
        completion: @escaping (Result<ResponseBatch, Error>) -> Void
    ) -> Cancellable {
        let outerCancellable = CancellableNode()

        requestAdapter.adapt(request: request) { [networkClient] adaptingResult in
            guard !outerCancellable.isCancelled else { return }

            switch adaptingResult {
            case let .success(adaptedRequest):
                let networkCancellable = networkClient.performRequest(adaptedRequest) { networkResult in
                    guard !outerCancellable.isCancelled else { return }

                    let result = networkResult
                        .map { ResponseBatch(adaptedRequest: adaptedRequest, networkResponse: $0) }
                        .mapError { $0 as Error }

                    completion(result)
                }

                outerCancellable.addCancellationHandler(networkCancellable.cancel)
            case let .failure(error):
                completion(.failure(error))
            }
        }

        return outerCancellable
    }
}
