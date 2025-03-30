//
//  Item_v1_05.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 23.08.2023.
//
// swiftlint:disable type_name

import Foundation

public struct Item_v1_05: Encodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case price = "Price"
        case quantity = "Quantity"
        case name = "Name"
        case amount = "Amount"
        case tax = "Tax"
        case ean13 = "Ean13"
        case shopCode = "ShopCode"
        case paymentMethod = "PaymentMethod"
        case paymentObject = "PaymentObject"
        case agentData = "AgentData"
        case supplierInfo = "SupplierInfo"
    }

    /// Наименование товара. Максимальная длина строки – 64 символова.
    var name: String
    /// Сумма в копейках. Целочисленное значение не более 10 знаков.
    var price: Int64 = 0
    /// Количество/вес - целая часть не более 8 знаков, дробная часть не более 3 знаков.
    var quantity: Double = 0.0
    /// Сумма в копейках. Целочисленное значение не более 10 знаков.
    var amount: Int64
    /// Тип оплаты
    var paymentMethod: PaymentMethod?
    /// Признак предмета расчета
    var paymentObject: PaymentObject_v1_05?
    /// Ставка налога
    var tax: Tax
    /// Штрих-код.
    var ean13: String?
    /// Код магазина. Необходимо использовать значение параметра Submerchant_ID, полученного в ответ при регистрации магазинов через xml. Если xml не используется, передавать поле не нужно.
    var shopCode: String?
    /// Данные агента
    var agentData: AgentData?
    /// Данные поставщика платежного агента
    var supplierInfo: SupplierInfo?

    public init(
        amount: Int64,
        price: Int64,
        name: String,
        tax: Tax,
        quantity: Double = 1,
        paymentObject: PaymentObject_v1_05? = nil,
        paymentMethod: PaymentMethod? = nil,
        ean13: String? = nil,
        shopCode: String? = nil,
        supplierInfo: SupplierInfo? = nil,
        agentData: AgentData? = nil
    ) {
        self.amount = amount
        self.price = price
        self.name = name
        self.tax = tax
        self.quantity = quantity
        self.paymentObject = paymentObject
        self.paymentMethod = paymentMethod
        self.ean13 = ean13
        self.shopCode = shopCode
        self.supplierInfo = supplierInfo
        self.agentData = agentData
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(price, forKey: .price)
        try container.encode(amount, forKey: .amount)
        try container.encode(quantity, forKey: .quantity)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(tax.rawValue, forKey: .tax)
        try container.encodeIfPresent(ean13, forKey: .ean13)
        try container.encodeIfPresent(shopCode, forKey: .shopCode)
        try container.encodeIfPresent(paymentMethod?.rawValue, forKey: .paymentMethod)
        try container.encodeIfPresent(paymentObject?.rawValue, forKey: .paymentObject)
        try container.encodeIfPresent(agentData, forKey: .agentData)
        try container.encodeIfPresent(supplierInfo, forKey: .supplierInfo)
    }
}
