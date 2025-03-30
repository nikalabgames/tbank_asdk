//
//  FeatureToggleService.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 11.01.2024.
//

import Foundation

public protocol IFeatureToggleService {
    /// Список всех зарегестрированных тоглов
    var toggles: [IFeatureToggle] { get }
    /// Проверка включен ли тогл
    func featureEnabled(_ toggle: FeatureToggle) -> Bool
    func featureEnabled(_ toggleCase: FeatureToggleList) -> Bool
}

protocol IFeatureToggleRegister {
    func register(toggles: [FeatureToggle])
}

protocol IOverridenTogglesProvider {
    func overridenToggles() -> [String: Bool]
}

extension IFeatureToggleRegister {
    func register(toggle: FeatureToggle) {
        register(toggles: [toggle])
    }
}

protocol IInternalFeatureToggleService: IFeatureToggleService, IFeatureToggleRegister, IOverridenTogglesProvider {
    var mutableToggles: [IFeatureToggleMutable] { get }
}

// MARK: - Toggle Service

final class FeatureToggleService: IInternalFeatureToggleService {

    /// Синглтон для единого доступа
    static let shared = FeatureToggleService()

    private let userDefaults: IUserDefaults

    private var registeredToggles: [FeatureToggle] = []

    /// Зарегестрированные тоглы
    var toggles: [IFeatureToggle] { registeredToggles }

    /// Тоглы с доступом к изменению значения
    var mutableToggles: [IFeatureToggleMutable] { registeredToggles }

    init(userDefaults: IUserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        let toggles = FeatureToggleList.allCases.map(\.value)
        register(toggles: toggles)
    }

    // MARK: - Methods

    func register(toggles: [FeatureToggle]) {
        toggles.forEach { passedToggle in
            let index = self.registeredToggles.firstIndex { togl in
                togl.id == passedToggle.id
            }

            if let index {
                self.registeredToggles[index] = passedToggle
            } else {
                self.registeredToggles.append(passedToggle)
            }
        }
    }

    func featureEnabled(_ toggle: FeatureToggle) -> Bool {
        featureEnabled(toggle.id)
    }

    func featureEnabled(_ toggleCase: FeatureToggleList) -> Bool {
        featureEnabled(toggleCase.value.id)
    }

    func overridenToggles() -> [String: Bool] {
        userDefaults.value(key: "asdk-sample-overriden-toggles.list") ?? [:]
    }

    private func featureEnabled(_ toggleId: String) -> Bool {
        let matchedToggle = toggles.first { $0.id == toggleId }
        assert(matchedToggle != nil, "Passed toggle is not registered")
        return matchedToggle?.isEnabled ?? false
    }
}
