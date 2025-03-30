//
//  AcquiringSdkConfiguration.swift
//  TinkoffASDKCore
//
//  Copyright (c) 2020 Tinkoff Bank
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
import UIKit

public enum AcquiringSdkLanguage: String {
    case ru
    case en
}

/// Конфигурация для экземпляра SDK
public class AcquiringSdkConfiguration: NSObject {
    public let credential: AcquiringSdkCredential
    public let serverEnvironment: AcquiringSdkEnvironment
    public let requestsTimeoutInterval: TimeInterval

    /// Окружение для получения конфига ASDK
    let configEnvironment: ConfigSdkEnvironment

    /// Окружение для сервиса тоглов
    let togglesEnvironment: TogglesEnvironment

    /// Язык платёжной формы. На каком языке сервер будет присылать тексты ошибок клиенту
    ///
    ///   - `ru` - форма оплаты на русском языке;
    ///   - `en` - форма оплаты на английском языке.
    ///
    /// По умолчанию (если параметр не передан) - форма оплаты считается на русском языке
    public private(set) var language: AcquiringSdkLanguage?

    /// Объект логирующий сетевые запросы. Для включения логов, передать свой объект реализовавший протокол ILogger
    /// или уже существующий дефолтный объект типа Logger.
    /// По дефолту nil, логи отключены
    let logger: ILogger?

    /// Объект, предоставляющий токен для подписи запроса в **Тинькофф Эквайринг API** на основе параметров,  отправляемых с body
    let tokenProvider: ITokenProvider?

    /// Версия вашего приложения
    let appVersionProvider: IStringProvider?

    /// Запрашивает данные и способ аутентификация для `URLSession`
    let urlSessionAuthChallengeService: IURLSessionAuthChallengeService?

    /// Инициализация конфигурации для `AcquiringSdk`
    ///
    /// - Parameters:
    ///   - credential: учетные данные `AcquiringSdkConfiguration` Выдается после подключения к **Тинькофф Эквайринг API**
    ///   - server: `AcquiringSdkEnvironment` по умолчанию используется `test` - тестовый сервер
    ///   - requestsTimeoutInterval: `TimeInterval` таймаут сетевых запросов, значение по-умолчанию - 40 секунд
    ///   - logger: `ILogger` Объект логирующий сетевые запросы
    ///   - tokenProvider: Объект, предоставляющий токен для подписи запроса в **Тинькофф Эквайринг API** на основе параметров,  отправляемых с body
    ///   - urlSessionAuthChallengeService: Запрашивает данные и способ аутентификация для `URLSession`.
    ///   При nil используется реализация на усмотрение `AcquiringSDK`
    ///   - appVersion: Версия вашего приложения, в которую вы интегрируете ASDK. Значение по-умолчанию - nil.
    /// - Returns: AcquiringSdkConfiguration
    public init(
        credential: AcquiringSdkCredential,
        server: AcquiringSdkEnvironment,
        requestsTimeoutInterval: TimeInterval = 40,
        logger: ILogger? = nil,
        tokenProvider: ITokenProvider? = nil,
        urlSessionAuthChallengeService: IURLSessionAuthChallengeService? = nil,
        appVersion: String? = nil
    ) {
        self.credential = credential
        self.requestsTimeoutInterval = requestsTimeoutInterval
        self.logger = logger
        self.tokenProvider = tokenProvider
        self.urlSessionAuthChallengeService = urlSessionAuthChallengeService
        serverEnvironment = server
        configEnvironment = ConfigSdkEnvironment(sdkEnv: server)
        togglesEnvironment = TogglesEnvironment(sdkEnv: server)
        appVersionProvider = AppVersionProvider(version: appVersion)
    }
}
