//
//  ReceiptFdv1_2.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 02.08.2023.
//
// swiftlint:disable type_name

import Foundation

public struct ReceiptFdv1_2: Encodable, Equatable {

    /// Версия ФФД.
    public let ffdVersion: FfdVersion = .version1_2
    /// Информация о клиенте.
    public var clientInfo: ClientInfo?
    /// Система налогообложения
    public var taxation: Taxation
    /// Электронный адрес для отправки чека покупателю
    /// Параметр `email` или `phone` должен быть заполнен.
    public var email: String?
    /// Телефон покупателя
    /// Параметр `email` или `phone` должен быть заполнен.
    public var phone: String?
    /// Идентификатор покупателя
    public var customer: String?
    /// Инн покупателя. Если ИНН иностранного гражданина, необходимо указать 00000000000
    public var customerInn: String?
    /// Массив, содержащий в себе информацию о товарах
    public var items: [Item_v1_2]
    /// Детали платежа. Если объект не передан, будет автоматически указана итоговая сумма чека с
    /// видом оплаты "Безналичный". Если передан объект receipt.Payments, то значение в Electronic
    ///  должно быть равно итоговому значению Amount в методе Init. При этом сумма введенных значений
    ///  по всем видам оплат, включая Electronic, должна быть равна сумме (Amount) всех товаров, переданных в
    ///  объекте receipt.Items.
    public var payments: Payments?
    /// Операционный реквизит чека (тег 1270)
    public var operatingCheckProps: OperatingCheckProps?
    /// Отраслевой реквизит чека (тег 1261)
    public var sectoralCheckProps: SectoralCheckProps?
    /// Дополнительный реквизит пользователя (тег 1084)
    public var addUserProp: AddUserProp?
    /// Дополнительный реквизит чека (БСО) (тег 1192)
    public var additionalCheckProps: String?

    private enum CodingKeys: String, CodingKey {
        case items = "Items"
        case ffdVersion = "FfdVersion"
        case email = "Email"
        case phone = "Phone"
        case taxation = "Taxation"
        case customer = "Customer"
        case customerInn = "CustomerInn"
        case clientInfo = "ClientInfo"
        case payments = "Payments"
        case operatingCheckProps = "OperatingСheckProps"
        case sectoralCheckProps = "SectoralCheckProps"
        case addUserProp = "AddUserProp"
        case additionalCheckProps = "AdditionalCheckProps"
    }

    public init(
        email: String?,
        taxation: Taxation,
        phone: String?,
        items: [Item_v1_2],
        customer: String? = nil,
        customerInn: String?,
        clientInfo: ClientInfo? = nil,
        payments: Payments? = nil,
        operatingCheckProps: OperatingCheckProps? = nil,
        sectoralCheckProps: SectoralCheckProps? = nil,
        addUserProp: AddUserProp? = nil,
        additionalCheckProps: String? = nil
    ) throws {
        try Receipt.validateMandatoryFields(phone: phone, email: email)

        self.taxation = taxation
        self.phone = phone
        self.email = email
        self.items = items
        self.customer = customer
        self.customerInn = customerInn
        self.clientInfo = clientInfo
        self.payments = payments
        self.operatingCheckProps = operatingCheckProps
        self.sectoralCheckProps = sectoralCheckProps
        self.addUserProp = addUserProp
        self.additionalCheckProps = additionalCheckProps
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(customer, forKey: .customer)
        try container.encodeIfPresent(customerInn, forKey: .customerInn)
        try container.encodeIfPresent(clientInfo, forKey: .clientInfo)
        try container.encode(ffdVersion, forKey: .ffdVersion)
        try container.encode(taxation.rawValue, forKey: .taxation)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(payments, forKey: .payments)
        try container.encodeIfPresent(operatingCheckProps, forKey: .operatingCheckProps)
        try container.encodeIfPresent(sectoralCheckProps, forKey: .sectoralCheckProps)
        try container.encodeIfPresent(addUserProp, forKey: .addUserProp)
        try container.encodeIfPresent(additionalCheckProps, forKey: .additionalCheckProps)
    }
}
