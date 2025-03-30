//
//  AcquiringCacheService.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 29.07.2024.
//

import Foundation

protocol IAcquiringCacheService {
    /// Определяет, требуется ли обновление кэша тоглов
    func shouldUpdateTogglesCache() -> Bool
    func getTogglesCache() -> [ToggleModel]?
    func saveTogglesCache(models: [ToggleModel])
}

final class AcquiringCacheService: IAcquiringCacheService {

    private let fileService: IFileService
    private let fileNameProvider: IFileNameProvider
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    private let userDefaults: IUserDefaults
    private let calendar: Calendar = .current

    init(
        fileService: IFileService,
        fileNameProvider: IFileNameProvider,
        jsonDecoder: JSONDecoder,
        jsonEncoder: JSONEncoder,
        userDefaults: IUserDefaults
    ) {
        self.fileService = fileService
        self.fileNameProvider = fileNameProvider
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
        self.userDefaults = userDefaults
    }

    func getTogglesCache() -> [ToggleModel]? {
        do {
            let data = try fileService.readFile(named: fileNameProvider.getTogglesCacheFileName())
            let result = try jsonDecoder.decode([ToggleModel].self, from: data)
            if result.isEmpty { return nil }
            return result
        } catch {
            return nil
        }
    }

    func saveTogglesCache(models: [ToggleModel]) {
        guard let contentsData = try? jsonEncoder.encode(models) else { return }
        try? fileService.writeFile(named: fileNameProvider.getTogglesCacheFileName(), contents: contentsData)
    }

    func shouldUpdateTogglesCache() -> Bool {
        guard let creationDate = fileService.fileModificationDate(named: fileNameProvider.getTogglesCacheFileName()) else { return true }
        var cacheAliveTimeInMinutes = 60
        let key = UserDefaults.formSampleAppKey(.getTogglesCacheAliveTime)
        if let sampleTestTime: Int = userDefaults.value(key: key) {
            cacheAliveTimeInMinutes = sampleTestTime
        }
        guard let expiredCacheDate = calendar.date(
            byAdding: .minute,
            value: cacheAliveTimeInMinutes,
            to: creationDate
        ) else { return true }
        return Date() > expiredCacheDate
    }
}
