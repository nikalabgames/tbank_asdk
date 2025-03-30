//
//
//  CardListViewController.swift
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

import TinkoffASDKCore
import UIKit

final class CardListViewController: UIViewController {
    // MARK: Dependencies

    private let presenter: ICardListViewOutput

    private let configuration: CardListScreenConfiguration

    // MARK: Views

    private lazy var cardListView = CardListView(configuration: configuration)

    // MARK: State

    private var snackBarViewController: ISnackbarController?

    private var sections: [CardListSection] = []

    // MARK: Init

    init(
        configuration: CardListScreenConfiguration,
        presenter: ICardListViewOutput,
        snackBarViewController: ISnackbarController? = nil
    ) {
        self.presenter = presenter
        self.configuration = configuration
        self.snackBarViewController = snackBarViewController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func loadView() {
        view = cardListView
        cardListView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        presenter.viewDidLoad()
    }

    // MARK: Initial Configuration

    private func setupNavigationItem() {
        navigationItem.title = configuration.navigationTitle
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = ""

        if isFirstInNavigationStack {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: Loc.TinkoffAcquiring.Button.close,
                style: .plain,
                target: self,
                action: #selector(closeButtonTapped)
            )
        }
    }

    private func buildEditBarButton() -> UIBarButtonItem {
        UIBarButtonItem(
            title: Loc.Acquiring.CardList.buttonChange,
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
    }

    private func buildDoneEditingBarButton() -> UIBarButtonItem {
        UIBarButtonItem(
            title: Loc.Acquiring.CardList.buttonDone,
            style: .plain,
            target: self,
            action: #selector(doneEditingButtonTapped)
        )
    }

    // MARK: Actions

    @objc private func closeButtonTapped() {
        presenter.viewDidTapCloseButton()
    }

    @objc private func editButtonTapped() {
        presenter.viewDidTapEditButton()
    }

    @objc private func doneEditingButtonTapped() {
        presenter.viewDidTapDoneEditingButton()
    }
}

// MARK: - ICardListViewController

extension CardListViewController: ICardListViewInput {

    func reload(sections: [CardListSection]) {
        self.sections = sections
        cardListView.reload(sections: sections)
    }

    func deleteItems(at array: [IndexPath]) {
        cardListView.deleteItems(at: array)
    }

    func disableViewUserInteraction() {
        cardListView.disableUserInteraction()
    }

    func enableViewUserInteraction() {
        cardListView.enableUserInteraction()
    }

    func showShimmer() {
        cardListView.startShimmer(showing: true, completion: {})
    }

    func hideShimmer(fetchCardsResult: Result<[PaymentCard], Error>) {
        cardListView.startShimmer(
            showing: false,
            completion: { [weak presenter] in
                presenter?.viewDidHideShimmer(fetchCardsResult: fetchCardsResult)
            }
        )
    }

    func showFullStub(data: BaseStubViewBuilder.InputData) {
        cardListView.setCollectionView(isHidden: true)
        cardListView.showStubView(data: data)
    }

    func hideStub() {
        cardListView.setCollectionView(isHidden: false)
        cardListView.hideStubView()
    }

    func closeScreen() {
        popOrDismiss()
    }

    func showDoneEditingButton() {
        navigationItem.rightBarButtonItem = buildDoneEditingBarButton()
    }

    func showEditButton() {
        navigationItem.rightBarButtonItem = buildEditBarButton()
    }

    func hideRightBarButton() {
        navigationItem.rightBarButtonItem = nil
    }

    func showNativeAlert(data: OkAlertData) {
        let alert = UIAlertController.okAlert(data: data)
        present(alert, animated: true)
    }

    func showRemovingCardSnackBar(text: String?) {
        let config = SnackbarView.Configuration(
            content: .loader(
                configuration: LoaderTitleView.Configuration(
                    title: UILabel.Configuration(
                        content: .plain(text: text, style: .bodyM())
                    )
                )
            ),
            style: .base
        )
        snackBarViewController = UIWindow.keyWindow.showSnack(animated: true, config: config, completion: nil)
    }

    func hideLoadingSnackbar() {
        snackBarViewController?.hideSnackView(
            animated: true,
            completion: { [weak self] _ in
                self?.presenter.viewDidHideRemovingCardSnackBar()
                self?.snackBarViewController = nil
            }
        )
    }

    func showAddedCardSnackbar(cardMaskedPan: String) {
        let config = SnackbarView.Configuration(
            content: .iconTitle(
                icon: Asset.Icons.addedCard.image,
                text: Loc.Acquiring.CardList.addSnackBar(cardMaskedPan)
            ),
            style: .base
        )

        presenter.viewDidShowAddedCardSnackbar()
        UIWindow.keyWindow.showSnackFor(
            seconds: SnackbarView.showTimeInterval,
            animated: false,
            config: config,
            didShowCompletion: nil,
            didHideCompletion: nil
        )
    }

    func showTextSnackBar(text: String) {
        UIWindow.keyWindow.showTextSnackBar(text: text)
    }

    func showProblemSnackBar(text: String) {
        UIWindow.keyWindow.showProblemSnackBar(text: text)
    }
}

// MARK: - CardListViewDelegate

extension CardListViewController: CardListViewDelegate {

    func didSelectCell(at indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .cards:
            presenter.viewDidTapCard(cardIndex: indexPath.item)
        case .addCard:
            presenter.viewDidTapAddCardCell()
        }
    }

    func cardListView(_ view: CardListView, didTapDeleteOn card: CardList.Card) {
        presenter.view(didTapDeleteOn: card)
    }
}
