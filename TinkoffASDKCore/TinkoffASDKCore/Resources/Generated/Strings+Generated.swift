// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Loc {
  internal enum APIError {
    /// Ошибка API экваринга
    internal static let failureError = Loc.tr("Localizable", "APIError.failureError", fallback: "Ошибка API экваринга")
    /// Некорректный ответ API
    internal static let invalidResponse = Loc.tr("Localizable", "APIError.invalidResponse", fallback: "Некорректный ответ API")
  }
  internal enum ASDKCoreError {
    /// Некорректный email. Пример правильной почты some@email.com
    internal static let invalidEmail = Loc.tr("Localizable", "ASDKCoreError.invalidEmail", fallback: "Некорректный email. Пример правильной почты some@email.com")
    /// Receipt объект должен иметь не пустое валидное поле 'phone' ИЛИ 'email'. [example-phone: '+79991459557'] или [example-email: some@email.com]
    internal static let missingReceiptFields = Loc.tr("Localizable", "ASDKCoreError.missingReceiptFields", fallback: "Receipt объект должен иметь не пустое валидное поле 'phone' ИЛИ 'email'. [example-phone: '+79991459557'] или [example-email: some@email.com]")
  }
  internal enum NetworkError {
    /// Пустой ответ
    internal static let emptyResponse = Loc.tr("Localizable", "NetworkError.emptyResponse", fallback: "Пустой ответ")
    /// Не удалось создать запрос
    internal static let failedToCreateRequest = Loc.tr("Localizable", "NetworkError.failedToCreateRequest", fallback: "Не удалось создать запрос")
    /// Ошибка сервера
    internal static let serverError = Loc.tr("Localizable", "NetworkError.serverError", fallback: "Ошибка сервера")
    /// Ошибка сети
    internal static let transportError = Loc.tr("Localizable", "NetworkError.transportError", fallback: "Ошибка сети")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Loc {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = Bundle.coreResources.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
