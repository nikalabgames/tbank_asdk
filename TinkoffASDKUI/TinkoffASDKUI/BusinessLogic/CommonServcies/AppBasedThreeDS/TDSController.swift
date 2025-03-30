//
//
//  TDSController.swift
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

import ThreeDSWrapper
import TinkoffASDKCore

typealias PaymentCompletionHandler = (_ result: Result<GetPaymentStatePayload, Error>) -> Void

/// Используется для проведения транзакции 3дс через App Based Flow
protocol ITDSController: AnyObject {
    var completionHandler: PaymentCompletionHandler? { get set }
    var cancelHandler: (() -> Void)? { get set }

    /// 1. Запускает App Based Flow проверку
    func startAppBasedFlow(
        check3dsPayload: Check3DSVersionPayload,
        completion: @escaping (Result<ThreeDsDataSDK, Error>) -> Void
    )

    /// 2. Начинает испытание на стороне 3дс-сдк
    func doChallenge(with appBasedData: Confirmation3DS2AppBasedData)

    /// Приостанавливает выполнение транзакции
    ///
    /// Используем в случае получения ошибок от асдк
    func stop()
}

final class TDSController: ITDSController {

    // Dependencies

    private let threeDsService: IAcquiringThreeDSService
    private let tdsWrapper: ITDSWrapper
    private let tdsTimeoutResolver: ITimeoutResolver
    private let tdsCertsManager: ITDSCertsManager
    private let threeDSDeviceInfoProvider: IThreeDSDeviceInfoProvider
    private let mainQueue: any IDispatchQueue

    // 3ds sdk properties

    private var transaction: ITransaction?
    private var progressView: ProgressDialog?
    private var challengeParams: ChallengeParameters?

    // Transaction completion handler

    var completionHandler: PaymentCompletionHandler?
    var cancelHandler: (() -> Void)?

    // Init
    init(
        threeDsService: IAcquiringThreeDSService,
        tdsWrapper: ITDSWrapper,
        tdsTimeoutResolver: ITimeoutResolver,
        tdsCertsManager: ITDSCertsManager,
        threeDSDeviceInfoProvider: IThreeDSDeviceInfoProvider,
        mainQueue: IDispatchQueue
    ) {
        self.threeDsService = threeDsService
        self.tdsWrapper = tdsWrapper
        self.tdsTimeoutResolver = tdsTimeoutResolver
        self.tdsCertsManager = tdsCertsManager
        self.threeDSDeviceInfoProvider = threeDSDeviceInfoProvider
        self.mainQueue = mainQueue
    }

    /// Запускает App Based Flow проверку
    func startAppBasedFlow(
        check3dsPayload: Check3DSVersionPayload,
        completion: @escaping (Result<ThreeDsDataSDK, Error>) -> Void
    ) {
        guard let paymentSystem = check3dsPayload.paymentSystem
        else {
            completion(.failure(AppBasedControllerError.noPaymentSystem))
            return
        }

        getDeviceInfo(
            paymentSystem: paymentSystem,
            messageVersion: check3dsPayload.version,
            completion: completion
        )
    }

    /// Начинает испытание на стороне 3дс-сдк
    func doChallenge(with appBasedData: Confirmation3DS2AppBasedData) {
        let challengeParams = ChallengeParameters()

        challengeParams.setAcsTransactionId(appBasedData.acsTransId)
        challengeParams.set3DSServerTransactionId(appBasedData.tdsServerTransId)
        challengeParams.setAcsRefNumber(appBasedData.acsRefNumber)
        challengeParams.setAcsSignedContent(appBasedData.acsSignedContent)

        self.challengeParams = challengeParams
        transaction?.doChallenge(
            challengeParameters: challengeParams,
            challengeStatusReceiver: self,
            timeout: tdsTimeoutResolver.challengeValue
        )
    }

    func stop() {
        finishTransaction { [weak self] in
            self?.clear()
        }
    }
}

// MARK: - Private

extension TDSController {

    /// Получает необходимые параметры для проведения 3дс
    private func getDeviceInfo(
        paymentSystem: String,
        messageVersion: String,
        completion: @escaping (Result<ThreeDsDataSDK, Error>) -> Void
    ) {
        tdsCertsManager.checkAndUpdateCertsIfNeeded(for: paymentSystem) { [weak self] result in
            guard let self = self else { return }

            do {
                let matchingDirectoryServerID = try result.get()
                // getting auth params
                let authParams = try self.startTransaction(
                    directoryServerID: matchingDirectoryServerID,
                    messageVersion: messageVersion
                )

                // enriching request with additional params
                let deviceInfo = self.gatherThreeDSDeviceInfo(
                    messageVersion: messageVersion,
                    authParams: authParams
                )

                completion(.success(deviceInfo))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Добавляет необходимые параметры в `FinishAuthorizeData`
    private func gatherThreeDSDeviceInfo(
        messageVersion: String,
        authParams: AuthenticationRequestParameters
    ) -> ThreeDsDataSDK {

        let sdkData = threeDSDeviceInfoProvider.createThreeDsDataSDK(
            sdkAppID: authParams.getSDKAppID(),
            sdkEphemPubKey: authParams.getSDKEphemeralPublicKey(),
            sdkReferenceNumber: authParams.getSDKReferenceNumber(),
            sdkTransID: authParams.getSDKTransactionID(),
            sdkMaxTimeout: tdsTimeoutResolver.mapiValue,
            sdkEncData: authParams.getDeviceData()
        )

        return sdkData
    }

    /// Запускаем app based flow сценарий
    private func startTransaction(
        directoryServerID: String,
        messageVersion: String
    ) throws -> AuthenticationRequestParameters {
        let transaction = try tdsWrapper.createTransaction(
            directoryServerID: directoryServerID,
            messageVersion: messageVersion
        )
        self.transaction = transaction

        mainQueue.async {
            self.progressView = transaction.getProgressView()
            self.progressView?.start()
        }

        let authParams = try transaction.getAuthenticationRequestParameters()

        let deviceDataString = authParams.getDeviceData()
        let deviceDataBase64 = Data(deviceDataString.utf8).base64EncodedString()

        let sdkEphemPubKey = authParams.getSDKEphemeralPublicKey()
        let sdkEphemPubKeyBase64 = Data(sdkEphemPubKey.utf8).base64EncodedString()

        return AuthenticationRequestParameters(
            deviceData: deviceDataBase64,
            sdkTransId: authParams.getSDKTransactionID(),
            sdkAppID: authParams.getSDKAppID(),
            sdkReferenceNum: authParams.getSDKReferenceNumber(),
            ephemeralPublic: sdkEphemPubKeyBase64,
            messageVersion: messageVersion
        )
    }

    private func buildCresValue(with transStatus: String) throws -> String {
        guard let challengeParams = challengeParams else { return "" }
        let acsTransID = try challengeParams.getAcsTransactionId()
        let threeDSTransID = try challengeParams.get3DSServerTransactionId()

        let cresValue = "{\"threeDSServerTransID\":\"\(threeDSTransID)\",\"acsTransID\":\"\(acsTransID)\",\"transStatus\":\"\(transStatus)\"}"

        let encodedString = Data(cresValue.utf8).base64EncodedString()
        let noPaddingEncodedString = encodedString.replacingOccurrences(of: "=", with: "")
        return noPaddingEncodedString
    }

    private func finishTransaction(completion: @escaping (() -> Void)) {
        type(of: mainQueue).performOnMain {
            self.progressView?.stop()
            self.transaction?.close()
            completion()
        }
    }

    private func clear() {
        progressView = nil
        challengeParams = nil
    }
}

// MARK: - ChallengeStatusReceiver Delegate

extension TDSController: ChallengeStatusReceiver {
    func completed(_ completionEvent: CompletionEvent) {
        do {
            let cresValue = try buildCresValue(with: completionEvent.getTransactionStatus())
            let cresData = CresData(cres: cresValue)

            threeDsService.submit3DSAuthorizationV2(data: cresData) { [weak self] result in
                self?.completionHandler?(result)
            }
        } catch {
            completionHandler?(.failure(error))
        }

        // Важно: Вызываем последним ибо buildCresValue полагается на сохранненое значение challengeParams
        stop()
    }

    func cancelled() {
        stop()
        cancelHandler?()
    }

    func timedout() {
        mainQueue.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            stop()
            completionHandler?(.failure(TDSFlowError.timeout))
        }
    }

    func protocolError(_ protocolErrorEvent: ProtocolErrorEvent) {
        stop()
        let error = TDSFlowError.protocolError(protocolErrorEvent)
        completionHandler?(.failure(error))
    }

    func runtimeError(_ runtimeErrorEvent: RuntimeErrorEvent) {
        stop()
        let error = TDSFlowError.runtimeError(runtimeErrorEvent)
        completionHandler?(.failure(error))
    }
}

// MARK: - Error

private extension TDSController {
    enum AppBasedControllerError: LocalizedError {
        case noPaymentSystem

        var errorDescription: String? {
            switch self {
            case .noPaymentSystem:
                return "Couldn't retrieve paymentSystem"
            }
        }
    }
}
