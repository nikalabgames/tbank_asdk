//
//
//  AttachCardRequest.swift
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

struct AttachCardRequest: AcquiringRequest {
    let baseURL: URL
    let path: String = "v2/AttachCard"
    let httpMethod: HTTPMethod = .post
    let parameters: HTTPParameters
    let terminalKeyProvidingStrategy: TerminalKeyProvidingStrategy = .always
    let tokenFormationStrategy: TokenFormationStrategy = .includeAll(except: Constants.Keys.data)

    init(
        data: AttachCardData,
        encryptor: IRSAEncryptor,
        cardDataFormatter: ICardDataFormatter,
        environmentProvider: IEnvironmentParametersProvider,
        valueForDataProvider: IValueForDataProvider,
        publicKey: SecKey,
        baseURL: URL
    ) {
        self.baseURL = baseURL
        parameters = .parameters(
            requestData: data,
            encryptor: encryptor,
            cardDataFormatter: cardDataFormatter,
            environmentProvider: environmentProvider,
            valueForDataProvider: valueForDataProvider,
            publicKey: publicKey
        )
    }
}

// MARK: HTTPParameters + Helpers

private extension HTTPParameters {
    static func parameters(
        requestData: AttachCardData,
        encryptor: IRSAEncryptor,
        cardDataFormatter: ICardDataFormatter,
        environmentProvider: IEnvironmentParametersProvider,
        valueForDataProvider: IValueForDataProvider,
        publicKey: SecKey
    ) -> HTTPParameters {
        var parameters: HTTPParameters = [Constants.Keys.requestKey: requestData.requestKey]

        let formattedCardData = cardDataFormatter.formatCardData(
            cardNumber: requestData.cardNumber,
            expDate: requestData.expDate,
            cvv: requestData.cvv
        )

        if let encryptedCardData = encryptor.encrypt(string: formattedCardData, publicKey: publicKey) {
            parameters[Constants.Keys.cardData] = encryptedCardData
        }

        var data: JSONObject = environmentProvider.environmentParameters

        if requestData.isUsing3DS, let requestData = try? requestData.data?.encode2JSONObject() {
            data = data.merging(requestData) { $1 }
        } else if let additionalData = try? requestData.data?.additionalData?.encode2JSONObject() {
            data = data.merging(additionalData) { $1 }
        }

        let tdsVersion = FinishAuthorizeRequest.findTdsVersion(data: requestData.data)
        if let togglesData = valueForDataProvider
            .formTogglesDataForAttachCard(tdsVersion: requestData.isUsing3DS ? tdsVersion : nil) {
            data = data.merging(togglesData) { $1 }
        }

        parameters[Constants.Keys.data] = data
        return parameters
    }
}
