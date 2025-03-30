//
//  RecurrentPaymentViewController.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 03.03.2023.
//

import UIKit
import WebKit

final class RecurrentPaymentViewController: UIViewController, IRecurrentPaymentViewInput {
    // MARK: Internal Types

    private enum PresentationState {
        case commonSheet
        case tableView
    }

    // MARK: Dependencies

    weak var pullableContentDelegate: IPullableContainerContentDelegate?
    private let presenter: IRecurrentPaymentViewOutput
    private let tableContentProvider: any IRecurrentPaymentTableContentProvider
    private let keyboardService = KeyboardService()

    // MARK: Subviews

    private lazy var tableView = UITableView(frame: view.bounds)
    private lazy var commonSheetView = CommonSheetView(delegate: self)
    private lazy var webView = WKWebView()

    // MARK: State

    private var presentationState: PresentationState = .commonSheet
    private var keyboardHeight: CGFloat = .zero

    // MARK: Initialization

    init(presenter: IRecurrentPaymentViewOutput, tableContentProvider: any IRecurrentPaymentTableContentProvider) {
        self.presenter = presenter
        self.tableContentProvider = tableContentProvider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "init with coder is unavailable.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsHierarchy()
        setupWebView()
        setupTableView()
        setupKeyboardObserving()
        presenter.viewDidLoad()
    }
}

// MARK: - IRecurrentPaymentViewInput

extension RecurrentPaymentViewController {
    func showCommonSheet(state: CommonSheetState, animatePullableContainerUpdates: Bool) {
        presentationState = .commonSheet

        commonSheetView.showOverlay(animated: true) {
            self.commonSheetView.set(state: state)

            self.pullableContentDelegate?.updateHeight(
                animated: animatePullableContainerUpdates,
                alongsideAnimation: { self.commonSheetView.hideOverlay(animated: !animatePullableContainerUpdates) }
            )
        }
    }

    func hideCommonSheet() {
        presentationState = .tableView

        commonSheetView.showOverlay(animated: true) {
            self.commonSheetView.set(state: .clear)

            self.pullableContentDelegate?.updateHeight(
                animated: true,
                alongsideAnimation: { self.commonSheetView.hideOverlay(animated: false) }
            )
        }
    }

    func hideKeyboard() {
        view.endEditing(true)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func closeView() {
        dismiss(animated: true, completion: presenter.viewWasClosed)
    }
}

// MARK: - UITableViewDataSource

extension RecurrentPaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableContentProvider.dequeueCell(from: tableView, at: indexPath, withType: presenter.cellType(at: indexPath))
    }
}

// MARK: - UITableViewDelegate

extension RecurrentPaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableContentProvider.height(for: presenter.cellType(at: indexPath), in: tableView)
    }
}

// MARK: - IPullableContainerContent

extension RecurrentPaymentViewController: IPullableContainerContent {
    func pullableContainer(
        _ contentDelegate: IPullableContainerContentDelegate,
        didRequestHeightForAnchorAt index: Int,
        availableSpace: CGFloat
    ) -> CGFloat {
        switch presentationState {
        case .tableView:
            return keyboardHeight + tableContentProvider.pullableContainerHeight(
                for: presenter.allCells(),
                in: tableView,
                availableSpace: availableSpace - keyboardHeight
            )
        case .commonSheet:
            return commonSheetView.estimatedHeight
        }
    }

    func pullableContainerWasClosed(_ contentDelegate: IPullableContainerContentDelegate) {
        presenter.viewWasClosed()
    }
}

// MARK: - ICommonSheetViewDelegate

extension RecurrentPaymentViewController: ICommonSheetViewDelegate {
    func commonSheetViewDidTapPrimaryButton(_ status: CommonSheetState.Status) {
        presenter.commonSheetViewDidTapPrimaryButton(status: status)
    }
}

// MARK: - ThreeDSWebFlowDelegate

extension RecurrentPaymentViewController: ThreeDSWebFlowDelegate {
    func hiddenWebViewToCollect3DSData() -> WKWebView { webView }
    func sourceViewControllerToPresent() -> UIViewController? { self }
}

// MARK: - Private

extension RecurrentPaymentViewController {
    private func setupViewsHierarchy() {
        view.addSubview(webView)
        webView.pinEdgesToSuperview()

        view.addSubview(tableView)
        tableView.pinEdgesToSuperview()

        view.addSubview(commonSheetView)
        commonSheetView.pinEdgesToSuperview()
    }

    private func setupWebView() {
        webView.isHidden = true
    }

    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .none
        tableView.delaysContentTouches = false
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = AsdkAccessibilityIdentifier.recurrentErrorSheet

        tableContentProvider.registerCells(in: tableView)
    }

    private func setupKeyboardObserving() {
        keyboardService.onHeightDidChangeBlock = { [weak self] keyboardHeight, _ in
            guard let self = self else { return }
            self.keyboardHeight = keyboardHeight
            self.pullableContentDelegate?.updateHeight()
        }
    }
}

// MARK: - IRecurrentPaymentViewOutput + Helpers

private extension IRecurrentPaymentViewOutput {
    func allCells() -> [RecurrentPaymentCellType] {
        (0 ..< numberOfRows()).map { cellType(at: IndexPath(row: $0, section: .zero)) }
    }
}
