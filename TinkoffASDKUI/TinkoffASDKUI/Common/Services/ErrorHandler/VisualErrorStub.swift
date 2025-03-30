//
//  VisualErrorStub.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 03.07.2024.
//

import Foundation

enum VisualErrorStub: Equatable {
    /// Не загрузилось - красный крест
    case timeoutRedCross
    /// Не загрузилось - песочные часы - Понятно
    case timeoutSandWatch
    /// Не загрузилось - песочные часы - К оплате
    case timeoutSandWatchMakeNewPayment
    /// У нас проблема - стандартная ошибка
    case weHaveProblem
    /// Не загрузилось - проблемы сети
    case notLoaded
    /// Не получилось оплатить
    case paymentFailure
    /// Не получилось оплатить - есть возможность оплатить другим способом
    case paymentFailureMakeNewPayment
    /// Ошибка нет карт - список карт
    case noCardsInCardList
    /// Ошибка нет карт - оплата картой
    case noCardsInCardPaymentList
}

extension VisualErrorStub {

    var commonSheetState: CommonSheetState {
        switch self {
        case .timeoutRedCross:
            CommonSheetState(
                status: .failed(self),
                title: nil,
                description: Loc.CommonStub.NoNetwork.title,
                primaryButtonTitle: Loc.Action.repeat,
                secondaryButtonTitle: nil
            )
        case .timeoutSandWatch:
            CommonSheetState(
                status: .failed(self),
                title: nil,
                description: Loc.CommonSheet.TimeoutFailed.title,
                primaryButtonTitle: Loc.CommonStub.SomeProblem.button,
                secondaryButtonTitle: nil
            )
        case .timeoutSandWatchMakeNewPayment:
            CommonSheetState(
                status: .failed(self),
                title: nil,
                description: Loc.CommonSheet.TimeoutFailed.title,
                primaryButtonTitle: Loc.CommonSheet.PaymentForm.toPayTitle,
                secondaryButtonTitle: nil
            )
        case .weHaveProblem:
            CommonSheetState(
                status: .failed(self),
                title: Loc.CommonAlert.SomeProblem.title,
                description: Loc.CommonStub.SomeProblem.description,
                primaryButtonTitle: Loc.CommonStub.SomeProblem.button,
                secondaryButtonTitle: nil
            )
        case .notLoaded:
            CommonSheetState(
                status: .failed(self),
                title: Loc.CommonStub.NoNetwork.title,
                description: Loc.CommonStub.NoNetwork.tryLater,
                primaryButtonTitle: Loc.Action.repeat,
                secondaryButtonTitle: nil
            )
        case .paymentFailure:
            CommonSheetState(
                status: .failed(self),
                title: Loc.CommonSheet.FailedPayment.title,
                description: Loc.CommonSheet.PaymentForm.contactStore,
                primaryButtonTitle: Loc.CommonStub.SomeProblem.button,
                secondaryButtonTitle: nil
            )
        case .paymentFailureMakeNewPayment:
            CommonSheetState(
                status: .failed(self),
                title: Loc.CommonSheet.FailedPayment.title,
                description: Loc.CommonSheet.PaymentFailed.tryAgain,
                primaryButtonTitle: Loc.CommonSheet.PaymentForm.toPayTitle,
                secondaryButtonTitle: nil
            )

        case .noCardsInCardList:
            CommonSheetState(
                status: .failed(self),
                title: nil,
                description: Loc.CommonStub.NoCards.description,
                primaryButtonTitle: Loc.CommonStub.NoCards.button,
                secondaryButtonTitle: nil
            )

        case .noCardsInCardPaymentList:
            CommonSheetState(
                status: .failed(self),
                title: nil,
                description: Loc.CommonStub.NoCardsToPay.description,
                primaryButtonTitle: Loc.CommonStub.NoCardsToPay.button,
                secondaryButtonTitle: nil
            )
        }
    }
}
