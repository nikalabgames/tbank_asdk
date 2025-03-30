//
//  FeatureToggleList.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 08.05.2024.
//

import Foundation

// MARK: - Список тоглов

public enum FeatureToggleList: CaseIterable {
    /// 3DS App Based flow
    ///
    /// Если включен -> для карт с 3дс 2.0 транзакция идет через 3ds sdk
    /// Если выключен -> для карт с 3дс 2.0 транзакция идет через 3ds Browser flow
    case appBased

    /// Логотип платежной формы
    ///
    /// Если включен ->  логотип отображается
    /// Если выключен -> логотип скрыт
    case mainFormLogoVisibility

    /// Позволяет включить/отключить Tpay на платежной форме в обход настроек терминала на ПФ
    ///
    /// Если включен -> отображение Tpay зависит от настроек терминала
    /// Если выключен ->  Tpay не отображается ( в не зависимости, что пришло на терминале )
    case tpayMethodVisibility

    /// Позволяет включить/отключить СБП на платежной форме в обход настроек терминала на ПФ
    ///
    /// Если включен -> отображение СБП  зависит от настроек терминала
    /// Если выключен ->  СБП не отображается ( в не зависимости, что пришло на терминале )
    case sbpMethodVisibility

    var value: FeatureToggle {
        switch self {
        case .appBased: return .appBased
        case .mainFormLogoVisibility: return .mainFormLogoVisibility
        case .tpayMethodVisibility: return .tpayMethodVisibility
        case .sbpMethodVisibility: return .sbpMethodVisibility
        }
    }

    public var id: String { value.id }

    init?(id: String) {
        let dictionary = Dictionary(uniqueKeysWithValues: Self.allCases.map { ($0.value.id, $0.self) })
        for (toggleId, caseValue) in dictionary where toggleId == id {
            self = caseValue
            return
        }
        return nil
    }
}
