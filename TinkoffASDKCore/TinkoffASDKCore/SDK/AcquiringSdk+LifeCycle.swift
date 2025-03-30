//
//  AcquiringSdk+DidLoad.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 29.07.2024.
//

import Foundation

extension AcquiringSdk {

    /// Вызывается после инициализации core sdk объекта
    func sdkDidLoad() async {
        await setupToggles()
    }

    /// Устанавливает значения тоглов из кеша
    private func setupToggles() async {
        togglesUpdater.updateLocalToggles(cacheService: cacheService, featureTogglesService: featureTogglesService)

        guard cacheService.shouldUpdateTogglesCache() else { return }

        let result = try? await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            self.getToggles { result in
                continuation.resume(with: result)
            }
        }

        guard let result else { return }
        cacheService.saveTogglesCache(models: result.items)
        togglesUpdater.updateLocalToggles(cacheService: cacheService, featureTogglesService: featureTogglesService)
    }
}
