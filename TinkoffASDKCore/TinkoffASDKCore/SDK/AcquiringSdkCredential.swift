//
//  AcquiringSdkCredential.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 15.07.2024.
//

import Foundation

public struct AcquiringSdkCredential {
    public var terminalKey: String
    public var publicKey: String

    /// - Parameters:
    ///   - terminalKey: ключ терминала. Выдается после подключения к **Тинькофф Эквайринг API**
    ///   - publicKey: публичный ключ. Выдается вместе с `terminalKey`
    /// - Returns: AcquiringSdkCredential
    public init(terminalKey: String, publicKey: String) {
        self.terminalKey = terminalKey
        self.publicKey = publicKey
    }
}
