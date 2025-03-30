//
//  ErrorHandlingResult.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 03.07.2024.
//

import Foundation

/// Результат обработки ошибки
enum ErrorHandlingResult: Equatable {
    case show(_ stub: VisualErrorStub, _ style: VisualErrorStyle)
    case showToast(_ toast: ToastError)
    case route(_ to: RoutePoint)
    case multistep(_ steps: [ErrorHandlingResult])
    case unhandled
}

enum RoutePoint {
    case tinkoffPayLanding
}
