//
//  VisualErrorStub+Icon.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 04.07.2024.
//

import Foundation
import class UIKit.UIImage

extension VisualErrorStub {

    /// Иллюстрация ошибки
    var iconImage: UIImage? {
        switch self {
        case .timeoutRedCross, .paymentFailure, .paymentFailureMakeNewPayment:
            Asset.Illustrations.redCross.image
        case .timeoutSandWatchMakeNewPayment, .timeoutSandWatch:
            Asset.Illustrations.sandclock.image
        case .weHaveProblem:
            Asset.Illustrations.alarm.image
        case .notLoaded:
            Asset.Illustrations.wiFiOff.image
        case .noCardsInCardList, .noCardsInCardPaymentList:
            Asset.Illustrations.cardCross.image
        }
    }

    /// Конвертирует в стаб для отображения в режим показа внутри контейнера вью (внутри экрана)
    func convertToFullStubMode(buttonAction: @escaping () -> Void) -> BaseStubViewBuilder.InputData {
        let sheetState = commonSheetState
        return BaseStubViewBuilder.InputData(
            icon: self.iconImage ?? UIImage(),
            title: sheetState.title ?? "",
            subtitle: sheetState.description ?? "",
            buttonTitle: sheetState.primaryButtonTitle ?? "",
            buttonAction: buttonAction
        )
    }
}
