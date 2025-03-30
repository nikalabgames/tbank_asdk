//
//  MainFormPaymentMethod.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 01.02.2023.
//

import Foundation
import TinkoffASDKCore

enum MainFormPaymentMethod: Hashable {
    case tinkoffPay(TinkoffPayMethod)
    case card
    case sbp
}

extension MainFormPaymentMethod {
    var priority: Int {
        switch self {
        case .tinkoffPay: return 0
        case .card: return 1
        case .sbp: return 2
        }
    }
}

extension MainFormPaymentMethod {
    var accessibilityIdentifier: String {
        switch self {
        case .tinkoffPay: return AsdkAccessibilityIdentifier.tinkoffPayMethod
        case .card: return AsdkAccessibilityIdentifier.cardMethod
        case .sbp: return AsdkAccessibilityIdentifier.sbpMethod
        }
    }
}
