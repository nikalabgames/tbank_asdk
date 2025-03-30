//
//  CommonSheetState.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 15.12.2022.
//

import Foundation
import UIKit

struct CommonSheetState: Equatable {

    enum Status: Equatable {
        case processing
        case succeeded
        case failed(VisualErrorStub)
    }

    // MARK: - Properties

    let status: Status?
    let title: String?
    let description: String?
    let primaryButtonTitle: String?
    let secondaryButtonTitle: String?

    init(
        status: Status? = nil,
        title: String? = nil,
        description: String? = nil,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil
    ) {
        self.status = status
        self.title = title
        self.description = description
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}

extension CommonSheetState {

    static let processing = CommonSheetState(
        status: .processing,
        title: Loc.CommonSheet.Processing.title,
        description: Loc.CommonSheet.Processing.description
    )

    static let plainProcessing = CommonSheetState(
        status: .processing
    )

    static var clear: CommonSheetState {
        CommonSheetState()
    }

    /// Успешно оплачено
    /// - Parameter amount: Сумма покупки
    static func paid(amount: String) -> CommonSheetState {
        CommonSheetState(
            status: .succeeded,
            title: "–\(amount)",
            description: Loc.CommonSheet.Paid.title,
            primaryButtonTitle: Loc.CommonSheet.Paid.primaryButton
        )
    }
}
