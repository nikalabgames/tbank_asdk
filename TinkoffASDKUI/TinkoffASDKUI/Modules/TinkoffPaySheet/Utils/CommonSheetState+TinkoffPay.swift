//
//  CommonSheetState+TinkoffPay.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 15.03.2023.
//

import Foundation

extension CommonSheetState {
    /// Область видимости для состояний `Tinkoff Pay`
    enum TinkoffPay {}

    /// Область видимости для состояний `Tinkoff Pay`
    static var tinkoffPay: TinkoffPay.Type { TinkoffPay.self }
}

extension CommonSheetState.TinkoffPay {
    static var processing: CommonSheetState {
        CommonSheetState(
            status: .processing,
            title: Loc.CommonSheet.TinkoffPay.Waiting.title,
            secondaryButtonTitle: Loc.CommonSheet.TinkoffPay.Waiting.secondaryButton
        )
    }
}
