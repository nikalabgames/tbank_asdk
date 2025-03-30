//
//  ISBPBanksAssembly.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 21.12.2022.
//

protocol ISBPBanksAssembly {

    /// Формирует модуль, когда уже есть пре загруженная платежная информация
    /// - Parameter paymentSheetOutput: делегат ответов от платежной шторки
    /// - Parameter paymentFlow: необходимые данные для платежа
    /// - Parameter isPresentingOverMainForm: флаг позволяет понять презентуется ли данный экран поверх платежной формы
    /// - Returns: Возвращает сформированный модуль
    func buildPreparedModule(
        paymentSheetOutput: ISBPPaymentSheetPresenterOutput?,
        paymentFlow: PaymentFlow,
        isPresentingOverMainForm: Bool
    ) -> SBPBanksModule

    /// Формирует модуль, когда нет загруженной платежной информации и требуется ее загрузить внутри модуля.
    /// Предназначен для внешнего использования, вместо paymentSheetOutput у него completion
    /// - Parameter paymentFlow: необходимые данные для платежа
    /// - Parameter isPresentingOverMainForm: флаг позволяет понять презентуется ли данный экран поверх платежной формы
    /// - Parameter completion: передает ответы от платежной шторки
    /// - Returns: Возвращает сформированный модуль
    func buildInitialModule(
        paymentFlow: PaymentFlow,
        isPresentingOverMainForm: Bool,
        completion: PaymentResultCompletion?
    ) -> SBPBanksModule

    /// Формирует модуль, когда нет загруженной платежной информации и требуется ее загрузить внутри модуля
    /// - Parameter paymentFlow: необходимые данные для платежа
    /// - Parameter output: необходим для передачи загруженных внутри модуля списка банков
    /// - Parameter isPresentingOverMainForm: флаг позволяет понять презентуется ли данный экран поверх платежной формы
    /// - Parameter paymentSheetOutput: делегат ответов от платежной шторки
    /// - Returns: Возвращает сформированный модуль
    func buildInitialModule(
        paymentFlow: PaymentFlow,
        output: ISBPBanksModuleOutput?,
        isPresentingOverMainForm: Bool,
        paymentSheetOutput: ISBPPaymentSheetPresenterOutput?
    ) -> SBPBanksModule
}
