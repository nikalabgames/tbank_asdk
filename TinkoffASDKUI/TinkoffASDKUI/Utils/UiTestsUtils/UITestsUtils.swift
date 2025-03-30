//
//  UITestsUtils.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 11.04.2024.
//

import Foundation
import TinkoffASDKCore

/// Класс для утилит - ui тестов
public struct UITestsUtils {

    public static let mockUrl = ProcessInfo.processInfo.environment[.mockServerUrl]
    public static let checkType = ProcessInfo.processInfo.environment[.checkType]

    /// Проверяем запущен ли UI Tests таргет
    public static func isUITests() -> Bool {
        return ProcessInfo.processInfo.environment[.UITests] != nil
    }

    /// Смотрит на файл config, если такой есть то смотрим ключи и сравниваем есть ли желаемый
    ///
    /// Используется для UI тестов, добавляя возможность в рантайме менять поведение
    public static func hasConfigKey(_ key: String) -> Bool {
        guard isUITests() else { return false }
        guard FileManager.default.fileExists(atPath: UiTestsConfigKeys.configFilePath) else { return false }
        guard let contentsData = FileManager.default.contents(atPath: UiTestsConfigKeys.configFilePath) else { return false }
        guard let contents = String(data: contentsData, encoding: .utf8) else { return false }
        let keys = contents.components(separatedBy: .newlines)
        return keys.contains(key)
    }

    public static func getConfiguredFeatureToggles() -> [String: Bool] {
        guard isUITests() else { return [:] }
        guard FileManager.default.fileExists(atPath: UiTestsConfigKeys.configFilePath),
              let contentsData = FileManager.default.contents(atPath: UiTestsConfigKeys.togglesFilePath),
              let contents = String(data: contentsData, encoding: .utf8) else { return [:] }

        var configDict: [String: Bool] = [:]
        let lines = contents.components(separatedBy: .newlines)
        for line in lines {
            guard !line.isEmpty else { continue }

            let components = line.components(separatedBy: "=")
            guard components.count == 2 else { continue }

            let key = components[0]
            let value = components[1] == "true"
            configDict[key] = value
        }

        return configDict
    }
}

// MARK: - Constants

private extension String {
    static let UITests = "UI_TESTS"
    static let mockServerUrl = "MOCK_SERVER_URL"
    static let checkType = "CHECK_TYPE"
}
