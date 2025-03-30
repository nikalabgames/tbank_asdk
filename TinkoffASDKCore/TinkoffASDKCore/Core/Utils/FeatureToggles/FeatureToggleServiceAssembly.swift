//
//  FeatureToggleServiceAssembly.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 11.01.2024.
//

import Foundation

public protocol IFeatureToggleServiceAssembly {
    func assemble() -> IFeatureToggleService
}

public final class FeatureToggleServiceAssembly: IFeatureToggleServiceAssembly {
    public init() {}

    public func assemble() -> IFeatureToggleService {
        FeatureToggleService.shared
    }

    func assembleInternal() -> IInternalFeatureToggleService {
        FeatureToggleService.shared
    }
}
