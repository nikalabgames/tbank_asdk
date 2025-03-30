//
//
//  UIViewController+Extensions.swift
//
//  Copyright (c) 2021 Tinkoff Bank
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

extension UIViewController {
    var isFirstInNavigationStack: Bool {
        navigationController?.viewControllers.first === self
    }

    func popOrDismiss(animated: Bool = true, completion: VoidBlock? = nil) {
        if let navigationController = navigationController, !isFirstInNavigationStack {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            navigationController.popViewController(animated: animated)
            CATransaction.commit()
        } else {
            dismiss(animated: animated, completion: completion)
        }
    }

    var topPresentedViewControllerOrSelfIfNotPresenting: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topPresentedViewControllerOrSelfIfNotPresenting
        } else {
            return self
        }
    }

    func presentOnTop(
        viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        topPresentedViewControllerOrSelfIfNotPresenting.present(
            viewController,
            animated: animated,
            completion: completion
        )
    }

    func dismissPresentedIfNeeded(animated: Bool = true, then completion: (() -> Void)? = nil) {
        if let presentedViewController = presentedViewController {
            if presentedViewController.isBeingPresented {
                transitionCoordinator?.animate(alongsideTransition: nil, completion: { _ in
                    self.dismiss(animated: animated, completion: completion)
                })
            } else if presentedViewController.isBeingDismissed {
                transitionCoordinator?.animate(alongsideTransition: nil, completion: { _ in
                    completion?()
                })
            } else {
                dismiss(animated: animated) {
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }
}
