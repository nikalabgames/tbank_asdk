//
//  MainFormTableContentProvider.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 18.04.2023.
//

import UIKit

final class MainFormTableContentProvider: IMainFormTableContentProvider {
    // MARK: Mirror Views

    private let shouldHideLogo: Bool
    private lazy var orderDetailsMirror = MainFormOrderDetailsView()
    private lazy var textHeaderMirror = TextAndImageHeaderView()

    init(shouldHideLogo: Bool) {
        self.shouldHideLogo = shouldHideLogo
    }

    // MARK: MainFormTableContentProvider

    func tableHeaderView() -> UIView? {
        if shouldHideLogo { return nil }
        return MainFormTableHeaderView(frame: .tableHeaderInitialFrame)
    }

    func registerCells(in tableView: UITableView) {
        tableView.register(
            MainFormOrderDetailsTableCell.self,
            SavedCardTableCell.self,
            SwitchTableCell.self,
            EmailTableCell.self,
            PayButtonTableCell.self,
            TextAndImageHeaderTableCell.self,
            AvatarTableViewCell.self
        )
    }

    func dequeueCell(
        from tableView: UITableView,
        at indexPath: IndexPath,
        withType cellType: MainFormCellType
    ) -> UITableViewCell {
        switch cellType {
        case let .orderDetails(presenter):
            let cell = tableView.dequeue(cellType: MainFormOrderDetailsTableCell.self, indexPath: indexPath)
            cell.containedView.presenter = presenter
            cell.insets = insets(for: cellType)
            cell.accessibilityIdentifier = AsdkAccessibilityIdentifier.orderDetails
            return cell
        case let .savedCard(presenter):
            let cell = tableView.dequeue(cellType: SavedCardTableCell.self, indexPath: indexPath)
            cell.containedView.presenter = presenter
            cell.insets = insets(for: cellType)
            cell.accessibilityIdentifier = AsdkAccessibilityIdentifier.mainFormSheetCardData
            return cell
        case let .getReceiptSwitch(presenter):
            let cell = tableView.dequeue(cellType: SwitchTableCell.self, indexPath: indexPath)
            cell.containedView.presenter = presenter
            cell.insets = insets(for: cellType)
            cell.accessibilityIdentifier = AsdkAccessibilityIdentifier.receiptSwitchData
            return cell
        case let .email(presenter):
            let cell = tableView.dequeue(cellType: EmailTableCell.self, indexPath: indexPath)
            cell.containedView.presenter = presenter
            cell.insets = insets(for: cellType)
            cell.accessibilityIdentifier = AsdkAccessibilityIdentifier.emailCell
            return cell
        case let .payButton(presenter):
            let cell = tableView.dequeue(cellType: PayButtonTableCell.self, indexPath: indexPath)
            cell.containedView.presenter = presenter
            cell.insets = insets(for: cellType)
            cell.accessibilityIdentifier = AsdkAccessibilityIdentifier.mainFormSheetPrimaryButton
            return cell
        case let .otherPaymentMethodsHeader(presenter):
            let cell = tableView.dequeue(cellType: TextAndImageHeaderTableCell.self, indexPath: indexPath)
            cell.containedView.presenter = presenter
            cell.insets = insets(for: cellType)
            return cell
        case let .otherPaymentMethod(paymentMethod):
            let cell = tableView.dequeue(cellType: AvatarTableViewCell.self, indexPath: indexPath)
            cell.setImageAccessibilityIdentifier(paymentMethod.accessibilityIdentifier)
            cell.update(with: .viewModel(from: paymentMethod))
            return cell
        }
    }

    func pullableContainerHeight(
        for cellTypes: [MainFormCellType],
        in tableView: UITableView,
        availableSpace: CGFloat
    ) -> CGFloat {
        let emailViewHeight = cellTypes.contains(where: \.isGetReceiptSwitch)
            ? EmailView.Constants.minimalHeight + UIEdgeInsets.emailInsets.vertical
            : .zero

        let contentHeight = cellTypes
            .filter { !$0.isEmail }
            .reduce(CGRect.tableHeaderInitialFrame.height + emailViewHeight) { $0 + height(for: $1, in: tableView) }

        return min(contentHeight, availableSpace)
    }

    func height(for cellType: MainFormCellType, in tableView: UITableView) -> CGFloat {
        let contentHeight: CGFloat = {
            switch cellType {
            case let .orderDetails(presenter):
                let presenterCopy = presenter.copy()
                orderDetailsMirror.presenter = presenterCopy
                return calculateHeight(for: orderDetailsMirror, in: tableView, using: .orderDetailsInsets)
            case .savedCard:
                return SavedCardView.Constants.minimalHeight
            case .getReceiptSwitch:
                return SwitchView.Constants.minimalHeight
            case .email:
                return EmailView.Constants.minimalHeight
            case .payButton:
                return PayButtonView.Constants.minimalHeight
            case let .otherPaymentMethodsHeader(presenter):
                let presenterCopy = presenter.copy()
                textHeaderMirror.presenter = presenterCopy
                return calculateHeight(for: textHeaderMirror, in: tableView, using: .otherPaymentMethodsHeaderInsets)
            case .otherPaymentMethod:
                return AvatarTableViewCell.Constants.minimalHeight
            }
        }()

        return contentHeight + insets(for: cellType).vertical
    }

    // MARK: Helpers

    private func insets(for cellType: MainFormCellType) -> UIEdgeInsets {
        switch cellType {
        case .orderDetails:
            return .orderDetailsInsets
        case .savedCard:
            return .savedCardInsets
        case .getReceiptSwitch:
            return .getReceiptSwitchInsets
        case .email:
            return .emailInsets
        case .payButton:
            return .payButtonInsets
        case .otherPaymentMethodsHeader:
            return .otherPaymentMethodsHeaderInsets
        case .otherPaymentMethod:
            return .zero
        }
    }

    private func calculateHeight(
        for view: UIView,
        in tableView: UITableView,
        using insets: UIEdgeInsets
    ) -> CGFloat {
        view.systemLayoutSizeFitting(
            CGSize(
                width: tableView.bounds.width - insets.horizontal,
                height: UIView.layoutFittingCompressedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
    }
}

// MARK: - Constants

private extension UIEdgeInsets {
    static let orderDetailsInsets = UIEdgeInsets(top: 32, left: 16, bottom: 28, right: 16)
    static let savedCardInsets = UIEdgeInsets(top: 8, left: 16, bottom: 20, right: 16)
    static let getReceiptSwitchInsets = UIEdgeInsets(top: .zero, left: 20, bottom: 12, right: 20)
    static let emailInsets = UIEdgeInsets(top: .zero, left: 16, bottom: 8, right: 16)
    static let payButtonInsets = UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16)
    static let otherPaymentMethodsHeaderInsets = UIEdgeInsets(vertical: 12, horizontal: 16)
}

private extension CGRect {
    static let tableHeaderInitialFrame = CGRect(origin: .zero, size: CGSize(width: .zero, height: 40))
}
