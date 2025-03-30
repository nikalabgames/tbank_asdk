//
//  UserDefaults+Ext.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 08.08.2024.
//

import Foundation

extension UserDefaults {
    enum SampleAppKey: String {
        case getTogglesCacheAliveTime = "TogglesCacheAliveTime"
    }
}

extension UserDefaults {
    static let sampleKey = "asdk-sample-"
    static func formSampleAppKey(_ subKey: SampleAppKey) -> String {
        sampleKey + subKey.rawValue
    }
}
