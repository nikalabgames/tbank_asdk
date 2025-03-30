//
//  FileService.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 29.07.2024.
//

import Foundation

/// Интерфейс для работы с файлами
protocol IFileService {
    /// Считывает данные из файла по имени
    func readFile(named: String) throws -> Data

    /// Записывает данные в файл по имени
    func writeFile(named: String, contents: Data) throws

    /// Получить дату создания файла.
    /// - Returns: `Date?` - Дата создания файла, если файл существует, иначе `nil`
    func fileModificationDate(named: String) -> Date?
}

final class FileService: IFileService {

    private let documentsURL: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private let userDefaults: IUserDefaults
    private let dateFormatter: DateFormatter

    init(userDefaults: IUserDefaults, dateFormatter: DateFormatter) {
        self.userDefaults = userDefaults
        self.dateFormatter = dateFormatter
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
    }

    func readFile(named: String) throws -> Data {
        let url = try formUrl(path: named)
        return try Data(contentsOf: url)
    }

    func writeFile(named: String, contents: Data) throws {
        let url = try formUrl(path: named)
        try contents.write(to: url)
        let dateString = dateFormatter.string(from: Date())
        userDefaults.set(value: dateString, forKey: named)
    }

    func fileModificationDate(named: String) -> Date? {
        do {
            let url = try formUrl(path: named)
            guard let dateString: String = userDefaults.value(key: named) else {
                return nil
            }
            return dateFormatter.date(from: dateString)
        } catch {
            return nil
        }
    }

    private func formUrl(path: String) throws -> URL {
        guard let documentsURL else { throw CacheError.noDocumentsURL }
        return documentsURL.appendingPathComponent(path, isDirectory: false)
    }

    enum CacheError: Error {
        case noDocumentsURL
    }
}
