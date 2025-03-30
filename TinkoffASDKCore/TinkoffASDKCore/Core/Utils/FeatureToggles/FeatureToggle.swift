//
//  FeatureToggle.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 11.01.2024.
//

import Foundation

public protocol IFeatureToggle {
    var description: String { get }
    var id: String { get }
    var isEnabled: Bool { get }
}

protocol IFeatureToggleMutable: IFeatureToggle {
    func set(isEnabled: Bool)
}

public final class FeatureToggle: IFeatureToggleMutable {
    public let description: String
    public let id: String
    public private(set) var isEnabled: Bool

    init(description: String, id: String, isEnabled: Bool) {
        self.description = description
        self.id = id
        self.isEnabled = isEnabled
    }

    public func set(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}
