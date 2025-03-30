//
//  CommonSheetViewController.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 12.12.2022.
//

import UIKit

final class CommonSheetViewController: UIViewController {
    // MARK: Dependencies

    weak var pullableContentDelegate: IPullableContainerContentDelegate?
    private let presenter: ICommonSheetPresenter

    // MARK: UI

    private lazy var commonSheetView = CommonSheetView(delegate: self)

    // MARK: Init

    init(presenter: ICommonSheetPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func loadView() {
        view = commonSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

// MARK: - ICommonSheetView

extension CommonSheetViewController: ICommonSheetView {
    func update(state: CommonSheetState, animatePullableContainerUpdates: Bool) {
        commonSheetView.showOverlay(animated: animatePullableContainerUpdates) {
            self.commonSheetView.set(state: state)

            self.pullableContentDelegate?.updateHeight(
                animated: animatePullableContainerUpdates,
                alongsideAnimation: {
                    self.commonSheetView.hideOverlay(animated: !animatePullableContainerUpdates)
                }
            )
        }
    }

    func close() {
        dismiss(animated: true, completion: presenter.viewWasClosed)
    }
}

// MARK: - ICommonSheetViewDelegate

extension CommonSheetViewController: ICommonSheetViewDelegate {
    func commonSheetViewDidTapPrimaryButton(_ status: CommonSheetState.Status) {
        presenter.primaryButtonTapped(status: status)
    }

    func commonSheetViewDidTapSecondaryButton(_ status: CommonSheetState.Status) {
        presenter.secondaryButtonTapped()
    }
}

// MARK: - IPullableContainerContent

extension CommonSheetViewController: IPullableContainerContent {
    func pullableContainerWasClosed(_ contentDelegate: IPullableContainerContentDelegate) {
        presenter.viewWasClosed()
    }

    func pullableContainerShouldDismissOnDownDragging(_ contentDelegate: IPullableContainerContentDelegate) -> Bool {
        presenter.canDismissViewByUserInteraction()
    }

    func pullableContainerShouldDismissOnDimmingViewTap(_ contentDelegate: IPullableContainerContentDelegate) -> Bool {
        presenter.canDismissViewByUserInteraction()
    }

    func pullableContainer(
        _ container: IPullableContainerContentDelegate,
        didRequestHeightForAnchorAt index: Int,
        availableSpace: CGFloat
    ) -> CGFloat {
        commonSheetView.estimatedHeight
    }
}
