//
//
//  PullableContainerViewController.swift
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

final class PullableContainerViewController: UIViewController {
    // MARK: UIViewController's Properties

    override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get { dimmingTransitioningDelegate }
        set {}
    }

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .custom }
        set {}
    }

    // MARK: Subviews

    private lazy var containerView = PullableContainerView()

    // MARK: Dependencies

    var contentType: (IPullableContainerContent & UIViewController).Type { type(of: content) }
    private let content: IPullableContainerContent & UIViewController
    private lazy var dimmingTransitioningDelegate = DimmingTransitioningDelegate(dimmingPresentationControllerDelegate: self)

    private lazy var heightConstraintController = PullableContainerHeightConstraintController(
        dragViewHeightConstraint: containerView.dragViewHeightConstraint,
        contentContainerHeightConstraint: containerView.contentContainerHeightConstraint,
        delegate: self
    )

    // MARK: State

    private var dragHandlers = [PullableContainerDragHandler]()
    private var cachedViewHeight: CGFloat = 0

    // MARK: Init

    init(content: IPullableContainerContent & UIViewController) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func loadView() {
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupDragHandlers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if cachedViewHeight != view.bounds.height {
            cachedViewHeight = view.bounds.height
            containerView.layoutIfNeeded()
            updateHeight()
        }
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }

    // MARK: Initial Configuration

    private func setupContent() {
        addChild(content)
        content.didMove(toParent: self)
        containerView.add(contentView: content.view)
    }

    private func setupDragHandlers() {
        let panGesture = UIPanGestureRecognizer()
        containerView.dragView.addGestureRecognizer(panGesture)

        let panGestureHandler: PullableContainerDragHandler = PullableContainerPanGestureDragHandler(
            heightConstraintController: heightConstraintController,
            panGestureRecognizer: panGesture
        )

        let scrollHandler: PullableContainerDragHandler? = content.pullableContainerDidRequestScrollView(self).map {
            PullableContainerScrollDragHandler(
                heightConstraintController: heightConstraintController,
                scrollView: $0
            )
        }

        dragHandlers = [panGestureHandler, scrollHandler].compactMap { $0 }
    }

    // MARK: Helpers

    private func calculateMaxContentHeight() -> CGFloat {
        view.bounds.height
            - containerView.safeAreaInsets.vertical
            - .additionalInset(for: view.safeAreaInsets)
            - containerView.headerView.bounds.height
    }
}

// MARK: - IPullableContainerContentDelegate

extension PullableContainerViewController: IPullableContainerContentDelegate {
    func updateHeight(animated: Bool, alongsideAnimation: VoidBlock?, completion: VoidBlock?) {
        dragHandlers.forEach { $0.cancel() }

        let updates = { [self] in
            alongsideAnimation?()
            self.heightConstraintController.updateHeight()
            self.containerView.layoutIfNeeded()
        }

        guard animated else {
            updates()
            completion?()
            return
        }

        UIView.animate(
            withDuration: 0.4,
            delay: .zero,
            usingSpringWithDamping: 1,
            initialSpringVelocity: .zero,
            options: .curveEaseInOut,
            animations: updates,
            completion: { _ in completion?() }
        )
    }
}

// MARK: - IPullableContainerHeightConstraintControllerDelegate

extension PullableContainerViewController: IPullableContainerHeightConstraintControllerDelegate {
    func heightConstraintControllerDidRequestNumberOfAnchors(_ controller: PullableContainerHeightConstraintController) -> Int {
        content.pullableContainerDidRequestNumberOfAnchors(self)
    }

    func heightConstraintController(_ controller: PullableContainerHeightConstraintController, didChange currentAnchorIndex: Int) {
        content.pullableContainer(self, didChange: currentAnchorIndex)
    }

    func heightConstraintControllerDidRequestCurrentAnchorIndex(_ controller: PullableContainerHeightConstraintController) -> Int {
        content.pullableContainerDidRequestCurrentAnchorIndex(self)
    }

    func heightConstraintController(_ controller: PullableContainerHeightConstraintController, didRequestHeightForAnchorAt index: Int) -> CGFloat {
        content.pullableContainer(self, didRequestHeightForAnchorAt: index, availableSpace: calculateMaxContentHeight())
    }

    func heightConstraintController(_ controller: PullableContainerHeightConstraintController, shouldUseAnchorAt index: Int) -> Bool {
        content.pullabeContainer(self, canReachAnchorAt: index)
    }

    func heightConstraintControllerDidEndDragging(_ controller: PullableContainerHeightConstraintController) {
        UIView.animate(
            withDuration: 0.4,
            delay: .zero,
            usingSpringWithDamping: 2,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: containerView.layoutIfNeeded
        )
    }

    func heightConstraintControllerDidCloseContainer(_ controller: PullableContainerHeightConstraintController) {
        dismiss(animated: true)

        content.pullableContainerWillBeClosed(self)
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            guard let self = self else { return }
            self.content.pullableContainerWasClosed(self)
        })
    }

    func heightConstraintControllerDidRequestMaxContentHeight(_ controller: PullableContainerHeightConstraintController) -> CGFloat {
        calculateMaxContentHeight()
    }

    func heightConstraintControllerDidRequestDragViewInset(_ controller: PullableContainerHeightConstraintController) -> UIEdgeInsets {
        UIEdgeInsets(top: containerView.headerView.bounds.height, left: .zero, bottom: containerView.safeAreaInsets.bottom, right: .zero)
    }

    func heightConstraintControllerShouldDismissOnDownDragging(_ controller: PullableContainerHeightConstraintController) -> Bool {
        content.pullableContainerShouldDismissOnDownDragging(self)
    }

    func heightConstraintController(_ controller: PullableContainerHeightConstraintController, didDragWithOffset offset: CGFloat) {
        content.pullableContainer(self, didDragWithOffset: offset)
    }
}

// MARK: - DimmingPresentationControllerDelegate

extension PullableContainerViewController: DimmingPresentationControllerDelegate {
    func dimmingPresentationControllerDidDismissByDimmingViewTap(_ dimmingPresentationController: DimmingPresentationController) {
        content.pullableContainerWillBeClosed(self)
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            guard let self = self else { return }
            self.content.pullableContainerWasClosed(self)
        })
    }

    func dimmingPresentationControllerShouldDismissOnDimmingViewTap(_ dimmingPresentationController: DimmingPresentationController) -> Bool {
        content.pullableContainerShouldDismissOnDimmingViewTap(self)
    }
}

// MARK: - Constants

private extension CGFloat {
    /// Определяет дополнительный отступ для шторки на основе нижнего safe area
    ///
    /// По значению `safeAreaInsets.bottom > 0` определяем, что у данного устройства есть челка. В такой ситуации отступ должен быть меньше.
    /// Значения отступов подобраны для соответствия максимальной высоты шторки и высоты нативного модального экрана
    static func additionalInset(for safeAreaInsets: UIEdgeInsets) -> CGFloat {
        safeAreaInsets.bottom > 0 ? 10 : 20
    }
}
