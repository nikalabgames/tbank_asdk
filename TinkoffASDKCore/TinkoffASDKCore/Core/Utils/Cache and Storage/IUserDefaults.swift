//
//  IUserDefaults.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 29.07.2024.
//

import Foundation

/// Абстракция над UserDefaults API
protocol IUserDefaults {

    /// Установить значение в хранилище
    /// - Parameters:
    ///   - value: значение
    ///   - forKey: ключ значения
    func set(value: Any?, forKey: String)

    /// Позволяет заполучить значение для переданного ключа
    /// - Parameter key: Ключ
    /// - Returns: Значение с указанным типом или же `nil` в случае ошибки
    func value<T>(key: String) -> T?
}

extension UserDefaults: IUserDefaults {

    /// Standalone user defaults for usage
    static let coreShared = UserDefaults(suiteName: (Bundle.main.bundleIdentifier ?? "") + "asdk-core") ?? .standard

    func set(value: Any?, forKey: String) {
        set(value, forKey: forKey)
    }

    func value<T>(key: String) -> T? {
        value(forKey: key) as? T
    }
}
