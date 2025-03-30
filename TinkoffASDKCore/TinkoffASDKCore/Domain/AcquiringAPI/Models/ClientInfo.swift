//
//  ClientInfo.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 10.08.2023.
//

import Foundation

public struct ClientInfo: Encodable, Equatable {
    /// Дата рождения покупателя (клиента) в формате ДД.ММ.ГГГГ
    public let birthdate: String?
    /// Числовой код страны, гражданином которой является покупатель (клиент).
    /// Код страны указывается в соответствии с Общероссийским классификатором стран мира ОКСМ.
    public let citizenship: String?
    /// Числовой код вида документа, удостоверяющего личность.
    public let documentCode: String?
    /// Реквизиты документа, удостоверяющего личность (например: серия и номер паспорта)
    public let documentData: String?
    /// Адрес покупателя (клиента), грузополучателя. Максимум 256 символов
    public let address: String?

    private enum CodingKeys: String, CodingKey {
        case birthdate = "Birthdate"
        case citizenship = "Citizenship"
        case documentCode = "DocumentCode"
        case documentData = "DocumentData"
        case address = "Address"
    }

    public init(birthdate: String?, citizenship: String?, documentCode: String?, documentData: String?, address: String?) {
        self.birthdate = birthdate
        self.citizenship = citizenship
        self.documentCode = documentCode
        self.documentData = documentData
        self.address = address
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(birthdate, forKey: .birthdate)
        try container.encodeIfPresent(citizenship, forKey: .citizenship)
        try container.encodeIfPresent(documentCode, forKey: .documentCode)
        try container.encodeIfPresent(documentData, forKey: .documentData)
        try container.encodeIfPresent(address, forKey: .address)
    }
}
