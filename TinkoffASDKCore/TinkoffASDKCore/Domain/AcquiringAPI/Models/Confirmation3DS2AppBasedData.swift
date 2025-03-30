//
//  Confirmation3DS2AppBasedData.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 07.10.2022.
//

import Foundation

public struct Confirmation3DS2AppBasedData: Codable, Equatable {
    private enum CodingKeys: CodingKey {
        case acsSignedContent
        case acsTransId
        case tdsServerTransId
        case acsRefNumber

        var stringValue: String {
            switch self {
            case .acsSignedContent: return Constants.Keys.acsSignedContent
            case .acsTransId: return Constants.Keys.acsTransId
            case .tdsServerTransId: return Constants.Keys.tdsServerTransId
            case .acsRefNumber: return Constants.Keys.acsRefNumber
            }
        }
    }

    public let acsSignedContent: String
    public let acsTransId: String
    public let tdsServerTransId: String
    public let acsRefNumber: String
}
