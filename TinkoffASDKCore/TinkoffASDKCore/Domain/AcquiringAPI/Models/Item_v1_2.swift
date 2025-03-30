//
//  Item_v1_2.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 23.08.2023.
//
// swiftlint:disable type_name

import Foundation

public struct Item_v1_2: Encodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case price = "Price"
        case quantity = "Quantity"
        case name = "Name"
        case amount = "Amount"
        case tax = "Tax"
        case paymentMethod = "PaymentMethod"
        case paymentObject = "PaymentObject"
        case agentData = "AgentData"
        case supplierInfo = "SupplierInfo"
        case userData = "UserData"
        case excise = "Excise"
        case countryCode = "CountryCode"
        case declarationNumber = "DeclarationNumber"
        case measurementUnit = "MeasurementUnit"
        case markProcessingMode = "MarkProcessingMode"
        case markCode = "MarkCode"
        case markQuantity = "MarkQuantity"
        case sectoralItemProps = "SectoralItemProps"
    }

    /// Наименование товара. Максимальная длина строки – 64 символова.
    var name: String
    /// Сумма в копейках. Целочисленное значение не более 10 знаков.
    var price: Int64
    /// Количество/вес - целая часть не более 8 знаков, дробная часть не более 3 знаков.
    var quantity: Double
    /// Сумма в копейках. Целочисленное значение не более 10 знаков.
    var amount: Int64
    /// Тип оплаты
    var paymentMethod: PaymentMethod
    /// Признак предмета расчета
    var paymentObject: PaymentObject_v1_2
    /// Ставка налога
    var tax: Tax
    /// Данные агента
    var agentData: AgentData?
    /// Данные поставщика платежного агента
    var supplierInfo: SupplierInfo?
    /// Дополнительный реквизит предмета расчета.
    var userData: String?
    /// Сумма акциза в рублях с учетом копеек, включенная в стоимость предмета расчета.
    var excise: String?
    /// Цифровой код страны происхождения товара в соответствии с Общероссийским классификатором стран мира (3 цифры)
    var countryCode: String?
    /// Номер таможенной декларации
    var declarationNumber: String?
    /// Единицы измерения. Передовать в соответствии с ОК 015-94 (МК 002-97))
    var measurementUnit: String
    /// Режим обработки кода маркировки. Должен принимать значение равное «0».
    /// Включается в чек в случае, если предметом расчета является товар, подлежащий
    /// обязательной маркировке средством идентификации (соответствующий код в поле paymentObject).
    var markProcessingMode: String
    /// Код маркировки в машиночитаемой форме, представленный в виде одного из видов кодов,
    /// формируемых в соответствии с требованиями, предусмотренными правилами, для нанесения
    ///  на потребительскую упаковку, или на товары, или на товарный ярлык
    var markCode: MarkCode?
    /// Реквизит «дробное количество маркированного товара». Передается только в случае,
    /// если расчет осуществляется за маркированный товар (соответствующий код в поле paymentObject)
    /// и значение в поле measurementUnit равно «0»
    var markQuantity: MarkQuantity?
    /// Отраслевой реквизит предмета расчета. Необходимо указывать только для товаров подлежащих
    /// обязательной маркировке средством идентификации и включение данного реквизита предусмотрено
    /// НПА отраслевого регулирования для соответствующей товарной группы.
    var sectoralItemProps: [SectoralItemProps]?

    public init(
        amount: Int64,
        price: Int64,
        name: String,
        tax: Tax,
        quantity: Double = 1,
        paymentObject: PaymentObject_v1_2,
        paymentMethod: PaymentMethod,
        supplierInfo: SupplierInfo? = nil,
        agentData: AgentData? = nil,
        userData: String? = nil,
        excise: String? = nil,
        countryCode: String? = nil,
        declarationNumber: String? = nil,
        measurementUnit: String,
        markProcessingMode: String,
        markCode: MarkCode? = nil,
        markQuantity: MarkQuantity? = nil,
        sectoralItemProps: [SectoralItemProps]? = nil
    ) {
        self.amount = amount
        self.price = price
        self.name = name
        self.tax = tax
        self.quantity = quantity
        self.paymentObject = paymentObject
        self.paymentMethod = paymentMethod
        self.supplierInfo = supplierInfo
        self.agentData = agentData
        self.userData = userData
        self.excise = excise
        self.countryCode = countryCode
        self.declarationNumber = declarationNumber
        self.measurementUnit = measurementUnit
        self.markProcessingMode = markProcessingMode
        self.markCode = markCode
        self.markQuantity = markQuantity
        self.sectoralItemProps = sectoralItemProps
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(price, forKey: .price)
        try container.encode(amount, forKey: .amount)
        try container.encode(quantity, forKey: .quantity)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(tax.rawValue, forKey: .tax)
        try container.encodeIfPresent(paymentMethod.rawValue, forKey: .paymentMethod)
        try container.encodeIfPresent(paymentObject.rawValue, forKey: .paymentObject)
        try container.encodeIfPresent(agentData, forKey: .agentData)
        try container.encodeIfPresent(supplierInfo, forKey: .supplierInfo)
        try container.encodeIfPresent(userData, forKey: .userData)
        try container.encodeIfPresent(excise, forKey: .excise)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(declarationNumber, forKey: .declarationNumber)
        try container.encode(measurementUnit, forKey: .measurementUnit)
        try container.encodeIfPresent(markProcessingMode, forKey: .markProcessingMode)
        try container.encodeIfPresent(markCode, forKey: .markCode)
        try container.encodeIfPresent(markQuantity, forKey: .markQuantity)
        try container.encodeIfPresent(sectoralItemProps, forKey: .sectoralItemProps)
    }
}
