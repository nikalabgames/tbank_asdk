//
//
//  FinishAuthorizeRequest.swift
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

struct FinishAuthorizeRequest: AcquiringRequest {
    let baseURL: URL
    let path: String = "v2/FinishAuthorize"
    let httpMethod: HTTPMethod = .post
    let parameters: HTTPParameters
    let terminalKeyProvidingStrategy: TerminalKeyProvidingStrategy = .always
    let tokenFormationStrategy: TokenFormationStrategy = .includeAll(except: Constants.Keys.data, Constants.Keys.deviceChannel)

    init(
        requestData: FinishAuthorizeData,
        encryptor: IRSAEncryptor,
        cardDataFormatter: ICardDataFormatter,
        ipAddressProvider: IIPAddressProvider,
        environmentParametersProvider: IEnvironmentParametersProvider,
        valueForDataProvider: IValueForDataProvider,
        publicKey: SecKey,
        baseURL: URL
    ) {
        self.baseURL = baseURL
        parameters = .parameters(
            requestData: requestData,
            encryptor: encryptor,
            cardDataFormatter: cardDataFormatter,
            ipAddressProvider: ipAddressProvider,
            environmentParametersProvider: environmentParametersProvider,
            valueForDataProvider: valueForDataProvider,
            publicKey: publicKey
        )
    }

    static func findTdsVersion(data: FinishAuthorizeDataEnum?) -> ThreeDSVersion? {
        switch data {
        case .threeDsSdk: return .appBased
        case .threeDsBrowser: return .v2
        case .dictionary: return .v1
        default: return nil
        }
    }
}

// MARK: - HTTPParameters + Helpers

private extension HTTPParameters {
    static func parameters(
        requestData: FinishAuthorizeData,
        encryptor: IRSAEncryptor,
        cardDataFormatter: ICardDataFormatter,
        ipAddressProvider: IIPAddressProvider,
        environmentParametersProvider: IEnvironmentParametersProvider,
        valueForDataProvider: IValueForDataProvider,
        publicKey: SecKey
    ) -> HTTPParameters {
        var parameters: HTTPParameters = [Constants.Keys.paymentId: requestData.paymentId]

        if let sendEmail = requestData.sendEmail {
            parameters[Constants.Keys.sendEmail] = sendEmail
        }

        if let infoEmail = requestData.infoEmail {
            parameters[Constants.Keys.infoEmail] = infoEmail
        }

        if let ipAddress = ipAddressProvider.ipAddress?.fullStringValue {
            parameters[Constants.Keys.ipAddress] = ipAddress
        }

        if let deviceChannel = requestData.deviceChannel {
            parameters[Constants.Keys.deviceChannel] = deviceChannel
        }

        if let amount = requestData.amount {
            parameters[Constants.Keys.amount] = amount
        }

        var dataParameters = (try? requestData.data?.encode2JSONObject()) ?? [:]
        dataParameters = dataParameters.merging(environmentParametersProvider.environmentParameters) { $1 }
        let tdsVersion = FinishAuthorizeRequest.findTdsVersion(data: requestData.data)
        if let togglesData = valueForDataProvider.formTogglesDataForFinishAuthorize(tdsVersion: tdsVersion) {
            dataParameters = dataParameters.merging(togglesData) { $1 }
        }

        parameters[Constants.Keys.data] = dataParameters

        switch requestData.paymentSource {
        case let .cardNumber(number, expDate, cvv):
            let formattedCardData = cardDataFormatter.formatCardData(cardNumber: number, expDate: expDate, cvv: cvv)
            if let encryptedCardData = encryptor.encrypt(string: formattedCardData, publicKey: publicKey) {
                parameters[Constants.Keys.cardData] = encryptedCardData
            }
        case let .savedCard(cardId, cvv):
            let formattedCardData = cardDataFormatter.formatCardData(cardId: cardId, cvv: cvv)

            if let encryptedCardData = encryptor.encrypt(string: formattedCardData, publicKey: publicKey) {
                parameters[Constants.Keys.cardData] = encryptedCardData
            }
        case .parentPayment:
            break
        }

        return parameters
    }
}
