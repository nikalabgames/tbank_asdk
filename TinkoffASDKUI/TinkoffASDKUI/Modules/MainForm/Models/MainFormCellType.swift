//
//  MainFormCellType.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 24.01.2023.
//

import Foundation

enum MainFormCellType {
    case orderDetails(any IMainFormOrderDetailsViewOutput)
    case savedCard(ISavedCardViewOutput)
    case getReceiptSwitch(ISwitchViewOutput)
    case email(IEmailViewOutput)
    case payButton(IPayButtonViewOutput)
    case otherPaymentMethodsHeader(any ITextAndImageHeaderViewOutput)
    case otherPaymentMethod(MainFormPaymentMethod)
}

extension MainFormCellType {
    var isGetReceiptSwitch: Bool {
        switch self {
        case .getReceiptSwitch:
            return true
        default:
            return false
        }
    }

    var isEmail: Bool {
        switch self {
        case .email:
            return true
        default:
            return false
        }
    }

    var isPayButton: Bool {
        switch self {
        case .payButton:
            return true
        default:
            return false
        }
    }
}

// MARK: - Equatable

extension MainFormCellType: Equatable {
    static func == (lhs: MainFormCellType, rhs: MainFormCellType) -> Bool {
        switch (lhs, rhs) {
        case (.orderDetails, .orderDetails),
             (.savedCard, .savedCard),
             (.getReceiptSwitch, .getReceiptSwitch),
             (.email, .email),
             (.payButton, .payButton),
             (.otherPaymentMethodsHeader, .otherPaymentMethodsHeader),
             (.otherPaymentMethod, .otherPaymentMethod):
            return true
        default: return false
        }
    }
}
