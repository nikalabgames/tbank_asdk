//
//  AsdkVersionProvider.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 28.08.2023.
//

import Foundation

public protocol IAsdkVersionProvider {
    var coreVersion: String { get }
    var uiVersion: String? { get }
    var ypVersion: String? { get }

    /// Формирует строку версий компонентов ASDK
    func formVersionString() -> String
}

public struct AsdkVersionProvider: IAsdkVersionProvider {
    public var coreVersion: String = Version.versionString
    public var uiVersion: String? { Self.uiVersion }
    public var ypVersion: String? { Self.ypVersion }

    public static var uiVersion: String?
    public static var ypVersion: String?

    /// Формирует строку версий компонентов ASDK
    public func formVersionString() -> String {
        var string = "core: \(coreVersion)"
        if let uiVersion = uiVersion { string += ", ui: \(uiVersion)" }
        if let ypVersion = ypVersion { string += ", yp: \(ypVersion)" }
        return string
    }
}
