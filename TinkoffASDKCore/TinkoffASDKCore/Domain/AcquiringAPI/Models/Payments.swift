//
//  Payments.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 23.08.2023.
//

import Foundation

public struct Payments: Encodable, Equatable {
    /// Вид оплаты "Наличные". Сумма к оплате в копейках
    public let cash: Int?
    /// Вид оплаты "Безналичный".
    public let electronic: Int
    /// Вид оплаты "Предварительная оплата (Аванс)".
    public let advancePayment: Int?
    /// Вид оплаты "Постоплата (Кредит)".
    public let credit: Int?
    /// Вид оплаты "Иная форма оплаты".
    public let provision: Int?

    private enum CodingKeys: String, CodingKey {
        case cash = "Cash"
        case electronic = "Electronic"
        case advancePayment = "AdvancePayment"
        case credit = "Credit"
        case provision = "Provision"
    }

    public init(cash: Int?, electronic: Int, advancePayment: Int?, credit: Int?, provision: Int?) {
        self.cash = cash
        self.electronic = electronic
        self.advancePayment = advancePayment
        self.credit = credit
        self.provision = provision
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cash, forKey: .cash)
        try container.encode(electronic, forKey: .electronic)
        try container.encodeIfPresent(advancePayment, forKey: .advancePayment)
        try container.encodeIfPresent(credit, forKey: .credit)
        try container.encodeIfPresent(provision, forKey: .provision)
    }
}
