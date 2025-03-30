//
//  AcquiringSdk+Assembly.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 06.10.2022.
//

import Foundation

public enum AcquiringSdkError: Error {
    case publicKey(String)
    case url
}

public extension AcquiringSdk {
    /// Создает новый экземпляр SDK
    convenience init(configuration: AcquiringSdkConfiguration) throws {
        let encryptor = RSAEncryptor()

        let publicKeyProvider = try PublicKeyProvider(string: configuration.credential.publicKey, encryptor: encryptor)
            .orThrow(AcquiringSdkError.publicKey(configuration.credential.publicKey))

        let acquiringURLProvider = try URLProvider(host: configuration.serverEnvironment.rawValue)
            .orThrow(AcquiringSdkError.url)

        let appBasedConfigURLProvider = try URLProvider(host: configuration.configEnvironment.rawValue)
            .orThrow(AcquiringSdkError.url)

        let togglesURLProvider = try URLProvider(host: configuration.togglesEnvironment.rawValue)
            .orThrow(AcquiringSdkError.url)

        let terminalKeyProvider = StringProvider(value: configuration.credential.terminalKey)
        let languageProvider = LanguageProvider(language: configuration.language)
        let asdkVersionProvider = AsdkVersionProvider()

        let networkSession = NetworkSession.build(
            requestsTimeout: configuration.requestsTimeoutInterval,
            authChallengeService: configuration.urlSessionAuthChallengeService
        )

        let vendorIdProvider: IStringProvider = VendorIdentifierProvider()
        let networkClient = NetworkClient.build(session: networkSession, logger: configuration.logger)
        let externalClient = ExternalAPIClient(networkClient: networkClient)
        let externalRequests = ExternalRequestBuilder(
            appBasedConfigURLProvider: appBasedConfigURLProvider,
            togglesURLProvider: togglesURLProvider,
            terminalKeyProvider: terminalKeyProvider,
            vendorIdentifierProvider: vendorIdProvider,
            asdkVersionProvider: asdkVersionProvider,
            appVersionProvider: configuration.appVersionProvider
        )
        let ipAddressProvider = IPAddressProvider(factory: IPAddressFactory())
        let deviceInfoProvider = DeviceInfoProvider()
        let acquiringDecoder = AcquiringDecoder()
        let urlDataLoader = URLDataLoader(networkClient: networkClient)

        let environmentParametersProvider = EnvironmentParametersProvider(
            deviceInfoProvider: deviceInfoProvider,
            asdkVersionProvider: asdkVersionProvider,
            language: configuration.language
        )

        let acquiringClient = AcquiringAPIClient.build(
            terminalKeyProvider: terminalKeyProvider,
            networkClient: networkClient,
            decoder: acquiringDecoder,
            tokenProvider: configuration.tokenProvider
        )

        let appBasedSdkUiProvider = AppBasedSdkUiProvider(
            prefferedInterface: .html
        )

        let threeDSFacade = ThreeDSFacade.build(
            acquiringURLProvider: acquiringURLProvider,
            languageProvider: languageProvider,
            appBasedSdkUiProvider: appBasedSdkUiProvider,
            decoder: acquiringDecoder
        )

        let featureTogglesService = FeatureToggleServiceAssembly().assembleInternal()
        let cacheService: IAcquiringCacheService = AcquiringCacheServiceAssembly()
            .assemble(terminalKey: configuration.credential.terminalKey)
        let togglesUpdater: ITogglesUpdater = TogglesUpdater()

        let valueForDataProvider = ValueForDataProvider(
            togglesService: featureTogglesService,
            cacheService: cacheService,
            vendorIdentifierProvider: vendorIdProvider
        )

        let acquiringRequests = AcquiringRequestBuilder(
            baseURLProvider: acquiringURLProvider,
            publicKeyProvider: publicKeyProvider,
            terminalKeyProvider: terminalKeyProvider,
            cardDataFormatter: CardDataFormatter(),
            rsaEncryptor: encryptor,
            ipAddressProvider: ipAddressProvider,
            environmentParametersProvider: environmentParametersProvider,
            valueForDataProvider: valueForDataProvider
        )

        self.init(
            acquiringAPI: acquiringClient,
            acquiringRequests: acquiringRequests,
            externalAPI: externalClient,
            externalRequests: externalRequests,
            ipAddressProvider: ipAddressProvider,
            threeDSFacade: threeDSFacade,
            languageProvider: languageProvider,
            urlDataLoader: urlDataLoader,
            featureTogglesService: featureTogglesService,
            cacheService: cacheService,
            togglesUpdater: togglesUpdater
        )
    }
}

// MARK: - AcquiringAPIClient

private extension AcquiringAPIClient {
    static func build(
        terminalKeyProvider: IStringProvider,
        networkClient: INetworkClient,
        decoder: IAcquiringDecoder,
        tokenProvider: ITokenProvider?
    ) -> IAcquiringAPIClient {
        AcquiringAPIClient(
            requestAdapter: AcquiringRequestAdapter(terminalKeyProvider: terminalKeyProvider, tokenProvider: tokenProvider),
            networkClient: networkClient,
            decoder: decoder
        )
    }
}

// MARK: - NetworkClient

private extension NetworkClient {
    static func build(session: INetworkSession, logger: ILogger?) -> NetworkClient {
        NetworkClient(
            session: session,
            requestBuilder: URLRequestBuilder(),
            statusCodeValidator: HTTPStatusCodeValidator(),
            logger: logger
        )
    }
}

// MARK: - NetworkSession

private extension NetworkSession {
    static func build(
        requestsTimeout: TimeInterval,
        authChallengeService: IURLSessionAuthChallengeService?
    ) -> NetworkSession {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = requestsTimeout
        urlSessionConfiguration.timeoutIntervalForResource = requestsTimeout
        urlSessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        lazy var defaultChallengeService = DefaultURLSessionAuthChallengeService(certificateValidator: CertificateValidator.shared)
        let authChallengeService = authChallengeService ?? defaultChallengeService
        let urlSessionDelegate = URLSessionDelegateImpl(authChallengeService: authChallengeService)

        let urlSession = URLSession(
            configuration: urlSessionConfiguration,
            delegate: urlSessionDelegate,
            delegateQueue: nil
        )

        return NetworkSession(urlSession: urlSession)
    }
}

// MARK: - ThreeDSFacade

private extension ThreeDSFacade {
    static func build(
        acquiringURLProvider: IURLProvider,
        languageProvider: ILanguageProvider,
        appBasedSdkUiProvider: IAppBasedSdkUiProvider,
        decoder: IAcquiringDecoder
    ) -> ThreeDSFacade {
        let urlBuilder = ThreeDSURLBuilder(baseURLProvider: acquiringURLProvider)
        let deviceInfoProvider = DeviceInfoProvider()
        let urlRequestBuilder = ThreeDSURLRequestBuilder(urlBuilder: urlBuilder, deviceInfoProvider: deviceInfoProvider)
        let webViewHandlerBuilder = ThreeDSWebViewHandlerBuilder(threeDSURLBuilder: urlBuilder, decoder: decoder)
        let deviceParamsProviderBuilder = ThreeDSDeviceParamsProviderBuilder(
            languageProvider: languageProvider,
            urlBuilder: urlBuilder,
            appBasedSdkUiProvider: appBasedSdkUiProvider
        )

        return ThreeDSFacade(
            threeDSURLBuilder: urlBuilder,
            threeDSURLRequestBuilder: urlRequestBuilder,
            webViewHandlerBuilder: webViewHandlerBuilder,
            deviceParamsProviderBuilder: deviceParamsProviderBuilder
        )
    }
}
