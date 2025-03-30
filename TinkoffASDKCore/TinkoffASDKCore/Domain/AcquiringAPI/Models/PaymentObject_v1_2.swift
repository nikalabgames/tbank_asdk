//
//  PaymentObject_v1_2.swift
//  TinkoffASDKCore
//
//  Created by Никита Васильев on 24.08.2023.
//
// swiftlint:disable type_name

import Foundation

/// Признак предмета расчета
public enum PaymentObject_v1_2: String, Equatable {
    /// товар
    case commodity
    /// подакцизный товар
    case excise
    /// работа
    case job
    /// услуга
    case service
    /// ставка азартной игры
    case gamblingBet = "gambling_bet"
    /// выигрыш азартной игры
    case gamblingPrize = "gambling_prize"
    /// лотерейный билет
    case lottery
    /// выигрыш лотереи
    case lotteryPrize = "lottery_prize"
    /// предоставление результатов интеллектуальной деятельности
    case intellectualActivity = "intellectual_activity"
    /// платеж
    case payment
    /// агентское вознаграждение
    case agentCommission = "agent_commission"
    /// Выплата
    case contribution
    /// Имущественное право
    case propertyRights = "property_rights"
    /// Внереализационный доход
    case unrealization
    /// Иные платежи и взносы
    case taxReduction = "tax_reduction"
    /// Торговый сбор
    case tradeFee = "trade_fee"
    /// Курортный сбор
    case resortTax = "resort_tax"
    /// Залог
    case pledge
    /// Расход
    case incomeDecrease = "income_decrease"
    /// Взносы на ОПС ИП
    case iePensionInsuranceWithoutPayments = "ie_pension_insurance_without_payments"
    /// Взносы на ОПС
    case iePensionInsuranceWithPayments = "ie_pension_insurance_with_payments"
    /// Взносы на ОМС ИП
    case ieMedicalInsuranceWithoutPayments = "ie_medical_insurance_without_payments"
    /// Взносы на ОМС
    case ieMedicalInsuranceWithPayments = "ie_medical_insurance_with_payments"
    /// Взносы на ОСС
    case socialInsurance = "social_insurance"
    /// Платеж казино
    case casinoChips = "casino_chips"
    /// Выдача ДС
    case agentPayment = "agent_payment"
    /// АТНМ
    case excisableGoodsWithoutMarkingCode = "excisable_goods_without_marking_code"
    /// AATM
    case excisableGoodsWithMarkingCode = "excisable_goods_with_marking_code"
    /// THM
    case goodsWithoutMarkingCode = "goods_without_marking_code"
    /// ТМ
    case goodsWithMarkingCode = "goods_with_marking_code"
    /// иной предмет расчета
    case another
}
