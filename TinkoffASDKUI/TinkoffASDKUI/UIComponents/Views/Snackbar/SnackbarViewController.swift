//
//  SnackbarViewController.swift
//  popup
//
//  Created by Ivan Glushko on 18.11.2022.
//

import UIKit

/// In order to use snacks make sure to conform to ISnackPresentable
final class SnackbarViewController: UIViewController {

    private(set) var state = State.hidden {
        didSet {
            stateDidChange(state: state)
        }
    }

    private var didSetStateToShownActions: [String: () -> Void] = [:]
    private var animations: [() -> Void] = []
    private var hasPendingHidingAnimation = false

    private var viewDidAppear = false
    private var showedAtTime: DispatchTime?

    private var snackbarView: SnackbarView?

    override func loadView() {
        view = PassthroughView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppear = true
        if !animations.isEmpty {
            animations.forEach { $0() }
        }

        animations = []
    }
}

extension SnackbarViewController: ISnackbarController {

    /// Показать снек (с анимацией)
    func showSnackView(config: SnackbarView.Configuration, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        state = .showing
        let snackbarView = SnackbarView()
        self.snackbarView = snackbarView
        view.addSubview(snackbarView)
        snackbarView.configure(with: config)
        let shownFrame = getShownSnackFrame()
        let hiddenFrame = getHiddenSnackFrame()
        snackbarView.frame = hiddenFrame
        snackbarView.frame.origin.y = .zero
        snackbarView.alpha = 0

        let firstStepAnimations: () -> Void = {
            snackbarView.frame.origin.y = shownFrame.origin.y
            snackbarView.alpha = 1
        }

        let localCompletion: ((Bool) -> Void)? = { [weak self] didComplete in
            self?.state = .shown
            completion?(didComplete)
        }

        if animated == false {
            let transformations = {
                firstStepAnimations()
                localCompletion?(true)
            }

            // run without animation
            transformations()
            // leaving the scope
            return
        }

        let animationItem = Animation(
            body: {
                firstStepAnimations()
            },
            completion: localCompletion
        )

        let animation = {
            UIView.animate(
                withDuration: .animation,
                delay: .zero,
                options: [],
                animations: {
                    animationItem.body()
                },
                completion: { didComplete in
                    animationItem.completion?(didComplete)
                }
            )
        }

        if !viewDidAppear {
            animations.append(animation)
        } else {
            animation()
        }
    }

    /// Убрать снек (с анимацией или без)
    func hideSnackView(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if state == .showing {
            didSetStateToShownActions[#function] = { [weak self] in
                self?.hideSnackView(animated: animated, completion: completion)
            }
        }

        guard state == .shown else { return }

        let hasPassedShowingTimeTreshold = hasPassedShowingTimeTreshold(
            timeTreshold: 1,
            hideAnimationBlock: {
                self.hideSnackView(animated: animated, completion: completion)
            }
        )

        guard hasPassedShowingTimeTreshold else { return }
        guard let snackbarView = snackbarView else { return }
        state = .hiding

        let animation = Animation(
            body: {
                snackbarView.frame = self.getHiddenSnackFrame()
                snackbarView.alpha = 0
            },
            completion: { [weak self] didComplete in
                self?.state = .hidden
                self?.view.removeFromSuperview()
                completion?(didComplete)
            }
        )

        if animated {
            UIView.animate(
                withDuration: .animation,
                delay: .zero,
                animations: {
                    animation.body()
                }, completion: { didComplete in
                    animation.completion?(didComplete)
                }
            )
        } else {
            animation.body()
            animation.completion?(true)
        }
    }
}

// MARK: - Private methods

extension SnackbarViewController {

    private func setupViews() {
        view.backgroundColor = .clear
    }

    private func getShownSnackFrame() -> CGRect {
        let size = snackbarView!.getSize()
        let centerX = UIScreen.main.bounds.center.x
        return CGRect(
            x: centerX - (size.width / 2),
            y: Constants.bottomInset + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? .zero),
            width: size.width,
            height: size.height
        )
    }

    private func getHiddenSnackFrame() -> CGRect {
        let shownFrame = getShownSnackFrame()
        return CGRect(
            x: shownFrame.origin.x,
            y: .zero,
            width: shownFrame.width,
            height: shownFrame.height
        )
    }

    private func stateDidChange(state: State) {
        switch state {
        case .hiding:
            break
        case .hidden:
            showedAtTime = nil
        case .showing:
            break
        case .shown:
            showedAtTime = .now()
            didSetStateToShownActions.values.forEach { closure in closure() }
        }
    }

    private func hasPassedShowingTimeTreshold(
        timeTreshold: Double,
        hideAnimationBlock: @escaping () -> Void
    ) -> Bool {

        var passedShowingTimeTreshold = true
        guard !hasPendingHidingAnimation else { return false }

        if let showedAtTime = showedAtTime {
            let diff = DispatchTime.now().uptimeNanoseconds - showedAtTime.uptimeNanoseconds
            let diffInSeconds = Double(diff) / 1_000_000_000

            passedShowingTimeTreshold = diffInSeconds > timeTreshold
            if !passedShowingTimeTreshold {
                hasPendingHidingAnimation = true

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + (timeTreshold - diffInSeconds),
                    execute: { [weak self] in
                        guard let self = self else { return }
                        self.hasPendingHidingAnimation = false
                        hideAnimationBlock()
                    }
                )
            }
        }
        return passedShowingTimeTreshold
    }
}

extension SnackbarViewController {

    enum State {
        case hiding
        case hidden
        case showing
        case shown
    }

    struct Animation {
        let body: () -> Void
        let completion: ((Bool) -> Void)?
    }

    struct Constants {

        static var sideInset: CGFloat { 16 }
        static var bottomInset: CGFloat { 24 }
    }
}

private extension TimeInterval {

    static let animation: Self = 0.300
}
