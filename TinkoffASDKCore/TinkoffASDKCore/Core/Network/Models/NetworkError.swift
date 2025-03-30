//
//  NetworkError.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 09.10.2022.
//

import Foundation

public enum NetworkError: LocalizedError, CustomNSError {
    case failedToCreateRequest(Error)
    case transportError(Error)
    case emptyResponse
    case serverError(statusCode: Int)

    public var errorCode: Int {
        switch self {
        case let .transportError(error):
            return (error as NSError).code
        case let .serverError(statusCode):
            return statusCode
        case .emptyResponse, .failedToCreateRequest:
            return -1
        }
    }

    public var errorDescription: String? {
        switch self {
        case .failedToCreateRequest:
            return Loc.NetworkError.failedToCreateRequest
        case let .transportError(error):
            return "\(Loc.NetworkError.transportError): \(error.localizedDescription)"
        case .emptyResponse:
            return Loc.NetworkError.emptyResponse
        case let .serverError(statusCode):
            return "\(Loc.NetworkError.serverError): \(statusCode)"
        }
    }
}
