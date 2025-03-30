//
//  IRecurrentPaymentFailiureDelegate.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 07.03.2023.
//

import TinkoffASDKCore

public typealias PaymentId = String

/// Делегат, обрабатывающий ошибку списания средств при вызове `v2/Charge`
///
/// Используется только при оплате на основе уже существующего `paymentId (PaymentFlow.finish)`
public protocol IRecurrentPaymentFailiureDelegate: AnyObject {
    /// В случае вызова этого метода делегата, необходимо совершить повторный запрос v2/Init, для получения обновленного paymentId
    /// для этого необходимо в запросе к полю DATA добавить additionalData (в PaymentOptions поле называется initData)
    /// - Parameters:
    ///   - additionalData: содержаться два доп. поля failMapiSessionId c failedPaymentId и recurringType
    ///   - completion: после успешного выполнения запроса, необходимо передать в completion новый paymentId
    func recurrentPaymentNeedRepeatInit(additionalInitData: AdditionalData, completion: @escaping (Result<PaymentId, Error>) -> Void)
}
