//
//  AcquiringCacheServiceAssembly.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 29.07.2024.
//

import Foundation

protocol IAcquiringCacheServiceAssembly {
    func assemble(terminalKey: String) -> IAcquiringCacheService
}

final class AcquiringCacheServiceAssembly: IAcquiringCacheServiceAssembly {
    func assemble(terminalKey: String) -> IAcquiringCacheService {
        AcquiringCacheService(
            fileService: FileService(userDefaults: UserDefaults.coreShared, dateFormatter: DateFormatter()),
            fileNameProvider: FileNameProvider(terminalKey: terminalKey),
            jsonDecoder: JSONDecoder(),
            jsonEncoder: JSONEncoder(),
            userDefaults: UserDefaults.standard
        )
    }
}
