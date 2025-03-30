//
//  UIWindow+Ext.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 27.10.2022.
//

import UIKit

extension UIWindow {

    static var globalSafeAreaInsets: UIEdgeInsets {
        guard let window = Self.findKeyWindow() else { return .zero }
        return window.safeAreaInsets
    }

    static func findKeyWindow() -> UIWindow? {

        if #available(iOS 13.0, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication
                .shared
                .keyWindow
        }
    }
}

extension UIWindow: ISnackBarPresentable, ISnackBarViewProvider {

    var viewProvider: ISnackBarViewProvider? { self }

    func viewToAddSnackBarTo() -> UIView { self }

    static var keyWindow: UIWindow {
        // if running unit tests
        if ProcessInfo.processInfo.processName.contains("xctest") {
            return UIWindow()
        } else {
            return findKeyWindow()!
        }
    }
}

extension ISnackBarPresentable where Self == UIWindow {

    /// На 5 секунд показывает текстовый снек
    func showTextSnackBar(text: String) {
        showSnackBar(text: text, icon: nil)
    }

    /// На 5 секунд показывает текстовый снек с картинкой red alert
    func showProblemSnackBar(text: String) {
        showSnackBar(text: text, icon: Asset.Illustrations.alertRed.image)
    }

    private func showSnackBar(text: String?, icon: UIImage?) {
        showSnackFor(
            seconds: SnackbarView.showTimeInterval,
            animated: true,
            config: SnackbarView.Configuration(content: .iconTitle(icon: icon, text: text), style: .base),
            didShowCompletion: nil,
            didHideCompletion: nil
        )
    }
}
