//
//  IErrorHandler.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 03.07.2024.
//

import Foundation

protocol IErrorHandler {

    /// Единая логика обработки ошибок
    /// - Parameters:
    ///   - error: Полученная ошибка
    ///   - screen: Экран на котором возникла ошибка
    ///   - event: Событие экрана на этапе которого получили ошибку
    ///   - info: Сюда прокидываем дополнительные данные для обработки ошибок
    /// - Returns: Возвращает результат обработки ошибки, что следует сделать
    func handle(
        error: Error,
        screen: SdkScreen,
        event: ScreenEvent,
        info: [ErrorHandlerInfoKey: Any]
    ) -> ErrorHandlingResult
}

extension IErrorHandler {

    // Пустой info
    func handle(
        error: Error,
        screen: SdkScreen,
        event: ScreenEvent
    ) -> ErrorHandlingResult {
        handle(error: error, screen: screen, event: event, info: [:])
    }
}
