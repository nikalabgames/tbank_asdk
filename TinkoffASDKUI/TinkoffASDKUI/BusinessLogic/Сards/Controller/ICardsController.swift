//
//  ICardsController.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 19.02.2023.
//

import Foundation
import TinkoffASDKCore

/// Объект, позволяющий совершать основные операции с картами пользователя
public protocol ICardsController: AnyObject {
    /// Объект, предоставляющий UI-компоненты для прохождения 3DS Web Based Flow при привязке карты
    var webFlowDelegate: (any ThreeDSWebFlowDelegate)? { get set }

    /// Идентификатор покупателя в системе Продавца, установленный для данного `ICardsController`
    var customerKey: String { get }

    /// Привязывает новую карту к пользователю
    ///
    /// После успешной привязки `ICardController` сделает запрос на полный список карт для определения привязанной карты
    /// - Parameters:
    ///   - cardData: Данные карты
    ///   - completion: Замыкание с результатом привязки, вызывающееся на главном потоке
    func addCard(cardData: CardData, completion: @escaping (AddCardResult) -> Void)

    /// Удаляет привязанную раннее карту
    /// - Parameters:
    ///   - cardId: Идентификатор карты в системе Банка
    ///   - completion: Замыкание с результатом удаления, вызывающееся на главном потоке
    func removeCard(cardId: String, completion: @escaping (Result<RemoveCardPayload, Error>) -> Void)

    /// Предоставляет список карт пользователя
    ///
    /// В данном методе возвращаются только карты со статусом `Active`
    /// - Parameter completion: Замыкание с результатом получения списка карт, вызывающееся на главном потоке
    func getActiveCards(completion: @escaping (Result<[PaymentCard], Error>) -> Void)
}
