//
//  Receipt.swift
//  TinkoffASDKCore
//
//  Created by r.akhmadeev on 07.10.2022.
//
// swiftlint:disable identifier_name

import Foundation

public enum Receipt: Equatable, Encodable {
    case version1_05(ReceiptFdv1_05)
    case version1_2(ReceiptFdv1_2)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .version1_05(info):
            try container.encode(info)
        case let .version1_2(info):
            try container.encode(info)
        }
    }

    /// Проверяет и валидирует наличие обязательных полей phone || email
    static func validateMandatoryFields(phone: String?, email: String?) throws {
        if let email = email {
            let isEmailValid = EmailValidator.validate(email)
            if !isEmailValid {
                throw ASDKCoreError.invalidEmail
            }
        }

        let checkValidaty: (String?) -> Bool = { input in
            let input = input?.trimmingCharacters(in: [" "])
            return (input != nil && input?.isEmpty == false)
        }

        let result = checkValidaty(phone) || checkValidaty(email)
        if !result {
            throw ASDKCoreError.missingReceiptFields
        }
    }
}
