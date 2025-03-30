//
//
//  CardPayment.swift
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

import TinkoffASDKCore

final class CardPaymentProcess: IPaymentProcess {

    private let paymentsService: IAcquiringPaymentsService
    private let threeDsService: IAcquiringThreeDSService
    private let threeDSDeviceInfoProvider: IThreeDSDeviceInfoProvider
    private let ipProvider: IIPAddressProvider
    private let featureToggleService: IFeatureToggleService
    private var isCancelled = Atomic(wrappedValue: false)
    private var currentRequest: Atomic<Cancellable?> = Atomic(wrappedValue: nil)

    let paymentSource: PaymentSourceData
    let paymentFlow: PaymentFlow
    private(set) var paymentId: String?

    private weak var delegate: PaymentProcessDelegate?

    init(
        paymentsService: IAcquiringPaymentsService,
        threeDsService: IAcquiringThreeDSService,
        threeDSDeviceInfoProvider: IThreeDSDeviceInfoProvider,
        ipProvider: IIPAddressProvider,
        featureToggleService: IFeatureToggleService,
        paymentSource: PaymentSourceData,
        paymentFlow: PaymentFlow,
        delegate: PaymentProcessDelegate
    ) {

        self.paymentsService = paymentsService
        self.threeDsService = threeDsService
        self.threeDSDeviceInfoProvider = threeDSDeviceInfoProvider
        self.ipProvider = ipProvider
        self.featureToggleService = featureToggleService
        self.paymentSource = paymentSource
        self.paymentFlow = paymentFlow
        self.delegate = delegate
    }

    func start() {
        switch paymentFlow {
        case let .full(paymentOptions):
            initPayment(data: .data(with: paymentOptions))
        case let .finish(paymentOptions):
            paymentId = paymentOptions.paymentId
            check3DSVersion(data: Check3DSVersionData(paymentId: paymentOptions.paymentId, paymentSource: paymentSource))
        }
    }

    func cancel() {
        isCancelled.store(newValue: true)
        currentRequest.wrappedValue?.cancel()
    }
}

private extension CardPaymentProcess {
    func initPayment(data: PaymentInitData) {
        let request = paymentsService.initPayment(data: data) { [weak self] result in
            guard let self = self else { return }
            guard !self.isCancelled.wrappedValue else { return }

            switch result {
            case let .success(payload):
                self.handleInitResult(payload: payload)
            case let .failure(error):
                let (cardId, rebillId) = self.paymentSource.getCardAndRebillId()
                self.delegate?.paymentDidFailed(self, with: error, cardId: cardId, rebillId: rebillId)
            }
        }
        currentRequest.store(newValue: request)
    }

    func check3DSVersion(data: Check3DSVersionData) {
        let request = threeDsService.check3DSVersion(data: data) { [weak self] result in
            guard let self = self else { return }
            guard !self.isCancelled.wrappedValue else { return }

            switch result {
            case let .success(payload):
                self.handleCheck3DSResult(payload: payload, paymentId: data.paymentId)
            case let .failure(error):
                let (cardId, rebillId) = self.paymentSource.getCardAndRebillId()
                self.delegate?.paymentDidFailed(self, with: error, cardId: cardId, rebillId: rebillId)
            }
        }
        currentRequest.store(newValue: request)
    }

    func finishAuthorize(data: FinishAuthorizeData, threeDSVersion: String? = nil) {
        let request = paymentsService.finishAuthorize(data: data) { [weak self] result in
            guard let self = self else { return }
            guard !self.isCancelled.wrappedValue else { return }

            switch result {
            case let .success(payload):
                self.handlePaymentFinish(payload: payload, threeDSVersion: threeDSVersion)
            case let .failure(error):
                let (cardId, rebillId) = self.paymentSource.getCardAndRebillId()
                self.delegate?.paymentDidFailed(self, with: error, cardId: cardId, rebillId: rebillId)
            }
        }
        currentRequest.store(newValue: request)
    }

    func handleInitResult(payload: InitPayload) {
        paymentId = payload.paymentId

        switch paymentSource {
        case .cardNumber, .savedCard:
            check3DSVersion(data: Check3DSVersionData(paymentId: payload.paymentId, paymentSource: paymentSource))
        case .parentPayment:
            // Log error
            assertionFailure("Only cardNumber or savedCard PaymentSourceData available")
        }
    }

    func handleCheck3DSResult(payload: Check3DSVersionPayload, paymentId: String) {
        func switch3dsVersion(_ version: ThreeDSVersion) {
            switch version {
            case .v1:
                let data = FinishAuthorizeData(
                    paymentId: paymentId,
                    paymentSource: paymentSource,
                    infoEmail: paymentFlow.customerOptions?.email,
                    data: .dictionary(paymentFlow.additionalFinishData ?? .empty())
                )
                finishAuthorize(data: data, threeDSVersion: payload.version)

            case .v2:
                guard let tdsServerTransID = payload.tdsServerTransID,
                      let threeDSMethodURL = payload.threeDSMethodURL
                else { return }
                let check3DSData = Checking3DSURLData(
                    tdsServerTransID: tdsServerTransID,
                    threeDSMethodURL: threeDSMethodURL,
                    notificationURL: threeDsService.confirmation3DSCompleteV2URL().absoluteString
                )

                delegate?.payment(self, needToCollect3DSData: check3DSData) { [weak self] threeDsBrowserData in
                    guard let self = self else { return }

                    let browserData = FinishAuthorizeDataWrapper<ThreeDsDataBrowser>(
                        data: threeDsBrowserData,
                        additionalData: self.paymentFlow.additionalFinishData
                    )

                    let data = FinishAuthorizeData(
                        paymentId: paymentId,
                        paymentSource: self.paymentSource,
                        infoEmail: self.paymentFlow.customerOptions?.email,
                        data: .threeDsBrowser(browserData)
                    )

                    self.finishAuthorize(data: data, threeDSVersion: payload.version)
                }

            case .appBased:
                guard featureToggleService.featureEnabled(.appBased) else {
                    switch3dsVersion(.v2)
                    break
                }
                delegate?.startAppBasedFlow(
                    check3dsPayload: payload,
                    completion: { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case let .success(threeDsSdkData):
                            let sdkData = FinishAuthorizeDataWrapper<ThreeDsDataSDK>(
                                data: threeDsSdkData,
                                additionalData: self.paymentFlow.additionalFinishData
                            )

                            let finishAuthorizeData = FinishAuthorizeData(
                                paymentId: paymentId,
                                paymentSource: self.paymentSource,
                                infoEmail: self.paymentFlow.customerOptions?.email,
                                data: .threeDsSdk(sdkData)
                            )
                            self.finishAuthorize(data: finishAuthorizeData)
                        case let .failure(error):
                            let (cardId, rebillId) = self.paymentSource.getCardAndRebillId()
                            self.delegate?.paymentDidFailed(self, with: error, cardId: cardId, rebillId: rebillId)
                        }
                    }
                )
            }
        }

        let version3ds = payload.receiveVersion()
        switch3dsVersion(version3ds)
    }

    func handlePaymentFinish(payload: FinishAuthorizePayload, threeDSVersion: String?) {
        guard !isCancelled.wrappedValue else { return }

        switch payload.responseStatus {
        case .done:
            handlePaymentResult(.success(payload.paymentState), rebillId: payload.rebillId)
        case let .needConfirmation3DS(data):
            delegate?.payment(
                self,
                need3DSConfirmation: data,
                confirmationCancelled: { [weak self] in
                    self?.handlePaymentCancelled(payload: payload)
                },
                completion: { [weak self] result in
                    self?.handlePaymentResult(result, rebillId: payload.rebillId)
                }
            )
        case let .needConfirmation3DSACS(data):
            let version: String = threeDSVersion ?? ""
            delegate?.payment(
                self,
                need3DSConfirmationACS: data,
                version: version,
                confirmationCancelled: { [weak self] in
                    self?.handlePaymentCancelled(payload: payload)
                },
                completion: { [weak self] result in
                    self?.handlePaymentResult(result, rebillId: payload.rebillId)
                }
            )
        case let .needConfirmation3DS2AppBased(data):
            let version: String = threeDSVersion ?? ""
            delegate?.payment(
                self,
                need3DSConfirmationAppBased: data,
                version: version,
                confirmationCancelled: { [weak self] in
                    self?.handlePaymentCancelled(payload: payload)
                },
                completion: { [weak self] result in
                    self?.handlePaymentResult(result, rebillId: payload.rebillId)
                }
            )
        case .unknown:
            break
        }
    }

    func handlePaymentCancelled(payload: FinishAuthorizePayload) {
        let cancelledState = GetPaymentStatePayload(
            paymentId: payload.paymentState.paymentId,
            amount: payload.paymentState.amount,
            orderId: payload.paymentState.orderId,
            status: .cancelled
        )
        handlePaymentResult(.success(cancelledState), rebillId: payload.rebillId)
    }

    func handlePaymentResult(_ result: Result<GetPaymentStatePayload, Error>, rebillId: String?) {
        let (sourceCardId, sourceRebillId) = paymentSource.getCardAndRebillId()

        switch result {
        case let .success(payload):
            delegate?.paymentDidFinish(
                self,
                with: payload,
                cardId: sourceCardId,
                rebillId: rebillId ?? sourceRebillId
            )
        case let .failure(error):
            delegate?.paymentDidFailed(
                self,
                with: error,
                cardId: sourceCardId,
                rebillId: rebillId ?? sourceRebillId
            )
        }
    }
}
