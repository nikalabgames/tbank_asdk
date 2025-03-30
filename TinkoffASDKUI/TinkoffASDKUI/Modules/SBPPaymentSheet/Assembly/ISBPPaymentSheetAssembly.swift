//
//  ISBPPaymentSheetAssembly.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 17.01.2023.
//

import UIKit

protocol ISBPPaymentSheetAssembly {

    /// Build sbp payment sheet module
    /// - Parameters:
    ///   - paymentId: Id of a payment
    ///   - output: Events output
    ///   - isPresentingOverMainForm: флаг позволяет понять презентуется ли данный экран поверх плтаежной формы
    /// - Returns: Sbp Payment Sheet View Controller
    func build(
        paymentId: String,
        paymentFlow: PaymentFlow,
        output: ISBPPaymentSheetPresenterOutput?,
        isPresentingOverMainForm: Bool
    ) -> UIViewController
}
