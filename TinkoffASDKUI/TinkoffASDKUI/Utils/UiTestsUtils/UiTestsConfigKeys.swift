//
//  UiTestsConfigKeys.swift
//  TinkoffASDKUI
//
//  Created by Gleb on 06.05.2024.
//

import Foundation

public struct UiTestsConfigKeys {

    private static let simulatorDirectory = (ProcessInfo.processInfo.environment["SIMULATOR_SHARED_RESOURCES_DIRECTORY"] ?? "")
    public static let configFilePath = simulatorDirectory + "/ui_tests_config"
    public static let togglesFilePath = simulatorDirectory + "/ui_tests_toggles"
    public static let networkLogsFilePath = simulatorDirectory + "/ui_tests_network_logs"

    public static let sbpBanksAreInstalled = "SBP_BANKS_ARE_INSTALLED"
    public static let tinkoffAppIsInstalled = "TINKOFF_APP_IS_INSTALLED"
    public static let scanCardIsNeeded = "SCAN_CARD_IS_NEEDED"
    public static let shouldNotSendEmail = "SHOULD_NOT_SEND_EMAIL"
    public static let combiInitIsEnabled = "COMBI_INIT_IS_ENABLED"
    public static let usedTerminalForUiTests = "USED_TERMINAL_FOR_UI_TESTS"
}
