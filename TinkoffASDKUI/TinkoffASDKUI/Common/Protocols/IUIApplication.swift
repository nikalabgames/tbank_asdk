//
//  IUIApplication.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 23.12.2022.
//

import UIKit

protocol IUIApplication {
    func canOpenURL(_ url: URL) -> Bool

    func open(
        _ url: URL,
        optionList: [UIApplication.OpenExternalURLOptionsKey: Any],
        completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?
    )
}

extension IUIApplication {
    func open(
        _ url: URL,
        completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?
    ) {
        open(url, optionList: [:], completionHandler: completion)
    }
}

extension UIApplication: IUIApplication {

    func open(
        _ url: URL,
        optionList: [OpenExternalURLOptionsKey: Any],
        completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?
    ) {
        open(url, options: optionList, completionHandler: completion)
    }
}
