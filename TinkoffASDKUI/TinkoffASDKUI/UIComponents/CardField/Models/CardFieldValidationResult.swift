//
//  CardFieldValidationResult.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 12.01.2023.
//

import Foundation

struct CardFieldValidationResult: Equatable {
    var cardNumberIsValid = false
    var expirationIsValid = false
    var cvcIsValid = false

    var isValid: Bool { cardNumberIsValid && expirationIsValid && cvcIsValid }

    func isFieldValid(type: CardFieldType) -> Bool {
        switch type {
        case .cardNumber: return cardNumberIsValid
        case .expiration: return expirationIsValid
        case .cvc: return cvcIsValid
        }
    }
}
