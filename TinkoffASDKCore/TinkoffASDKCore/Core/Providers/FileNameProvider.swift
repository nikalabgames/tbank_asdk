//
//  FileNameProvider.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 03.09.2024.
//

import Foundation

protocol IFileNameProvider {
    /// Файл с ответом от `/GetToggles`
    func getTogglesCacheFileName() -> String
}

final class FileNameProvider: IFileNameProvider {

    private let terminalKey: String

    init(terminalKey: String) {
        self.terminalKey = terminalKey
    }

    func getTogglesCacheFileName() -> String {
        "getToggles_\(terminalKey).json"
    }
}
