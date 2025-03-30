//
//  TogglesUpdater.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 29.07.2024.
//

import Foundation

protocol ITogglesUpdater {

    /// Обновляет локальные тоглы на значение тоглов из кеша
    /// - Returns: Список обновленных тоглов
    @discardableResult
    func updateLocalToggles(
        cacheService: IAcquiringCacheService,
        featureTogglesService: IInternalFeatureToggleService
    ) -> Set<FeatureToggleList>
}

final class TogglesUpdater: ITogglesUpdater {

    @discardableResult
    func updateLocalToggles(
        cacheService: IAcquiringCacheService,
        featureTogglesService: IInternalFeatureToggleService
    ) -> Set<FeatureToggleList> {
        let localToggles = featureTogglesService.mutableToggles
        lazy var cache = cacheService.getTogglesCache() ?? []
        lazy var overridenToggles = featureTogglesService.overridenToggles()
        var updatedToggles: Set<FeatureToggleList> = []

        for localToggle in localToggles {
            if let overridenToggle = overridenToggles.first(where: { $0.key == localToggle.id }),
               let toggleCase = FeatureToggleList(id: localToggle.id) {
                localToggle.set(isEnabled: overridenToggle.value)
                updatedToggles.insert(toggleCase)
            } else if let remoteToggle = cache.first(where: { $0.path == localToggle.id }),
                      let toggleCase = FeatureToggleList(id: localToggle.id) {
                localToggle.set(isEnabled: remoteToggle.value)
                updatedToggles.insert(toggleCase)
            }
        }

        return updatedToggles
    }
}
