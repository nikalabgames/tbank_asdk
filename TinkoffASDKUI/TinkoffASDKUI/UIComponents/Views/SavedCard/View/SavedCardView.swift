//
//  SavedCardView.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 24.01.2023.
//

import UIKit

typealias SavedCardTableCell = TableCell<SavedCardView>

final class SavedCardView: UIView {
    // MARK: Internal Types

    enum Constants {
        static let minimalHeight: CGFloat = 64
        static let iconLeadingInset: CGFloat = 16
        static let labelsStackSpacing: CGFloat = 4
        static let labelsStackHorizontalInset: CGFloat = 16
        static let cvcFieldTrailingInset: CGFloat = 8
        static let accessoryViewWidth: CGFloat = 83

        static let iconSize = CGSize(width: 40, height: 26)
        static let cvcFieldContainerSize = CGSize(width: 59, height: 48)
        static let cvcFieldCornerRadius: CGFloat = 12
        static let cvcFieldHeader = "CVC"
        static let cvcFieldPlaceholder = "123"
    }

    // MARK: Dependencies

    var presenter: ISavedCardViewOutput? {
        didSet {
            if oldValue?.view === self { oldValue?.view = nil }
            presenter?.view = self
        }
    }

    private lazy var maskingDelegate = CardFieldMaskingFactory().buildMaskingDelegate(for: .cvc, listener: self)

    // MARK: Content Container Subviews

    private lazy var containerView = CardContainerView(
        style: .prominentOnElevation1,
        onTap: { [weak self] in self?.presenter?.savedCardViewIsSelected() }
    )

    // MARK: Icon Subviews

    private lazy var iconView = DynamicIconCardView()

    // MARK: Label Subviews

    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = ASDKColors.Text.primary.color
        return label
    }()

    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = ASDKColors.Text.accent.color
        return label
    }()

    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Constants.labelsStackSpacing
        return stack
    }()

    // MARK: CVC Field Subviews

    private lazy var cvcField = FloatingTextField(insetsType: .smallInsets)

    private lazy var accessoryView: UIView = {
        let view = UIView()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(accessoryViewTapped))
        view.addGestureRecognizer(recognizer)
        view.isHidden = true
        return view
    }()

    private lazy var accessoryViewWidthConstraint = accessoryView.widthAnchor.constraint(equalToConstant: Constants.accessoryViewWidth)

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Initial Configuration

    private func setupView() {
        setupLayout()
        configureCVCField()
    }

    private func setupLayout() {
        addSubview(containerView)

        let contentView = containerView.contentView

        contentView.addSubview(iconView)
        contentView.addSubview(labelsStack)
        contentView.addSubview(accessoryView)
        accessoryView.addSubview(cvcField)
        labelsStack.addArrangedSubviews(cardNameLabel, actionLabel)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        cvcField.translatesAutoresizingMaskIntoConstraints = false

        containerView.pinEdgesToSuperview()

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.minimalHeight),

            iconView.widthAnchor.constraint(equalToConstant: Constants.iconSize.width),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: Constants.iconSize.height),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.iconLeadingInset),

            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.labelsStackHorizontalInset),
            labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Constants.labelsStackHorizontalInset),
            labelsStack.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor).with(priority: .defaultLow),

            accessoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            accessoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            accessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            cvcField.widthAnchor.constraint(equalToConstant: Constants.cvcFieldContainerSize.width),
            cvcField.heightAnchor.constraint(equalToConstant: Constants.cvcFieldContainerSize.height),
            cvcField.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor),
            cvcField.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor, constant: -Constants.cvcFieldTrailingInset),
        ])
    }

    private func configureCVCField() {
        cvcField.delegate = maskingDelegate
        cvcField.set(placeholder: Constants.cvcFieldPlaceholder)
        cvcField.set(clearButtonMode: .never)
        cvcField.set(contentType: .creditCardNumber)
        cvcField.set(keyboardType: .numberPad)
        cvcField.set(isSecureTextEntry: true)
        cvcField.setHeader(text: Constants.cvcFieldHeader)
        cvcField.setHeader(color: ASDKColors.Text.secondary.color)
        cvcField.setContainerView(radius: Constants.cvcFieldCornerRadius)
    }

    // MARK: Events

    @objc private func accessoryViewTapped() {
        cvcField.becomeFirstResponder()
    }
}

// MARK: ISavedPaymentCardViewInput

extension SavedCardView: ISavedCardViewInput {
    func update(with viewModel: SavedCardViewModel) {
        iconView.configure(model: viewModel.iconModel)
        cardNameLabel.text = viewModel.cardName
        actionLabel.text = viewModel.actionDescription
    }

    func showCVCField() {
        accessoryView.isHidden = false
        accessoryViewWidthConstraint.isActive = true
    }

    func hideCVCField() {
        accessoryView.isHidden = true
        accessoryViewWidthConstraint.isActive = false
    }

    func setCVCText(_ text: String) {
        cvcField.set(text: text)
    }

    func setCVCFieldValid() {
        cvcField.setHeader(color: ASDKColors.Text.secondary.color)
    }

    func setCVCFieldInvalid() {
        cvcField.setHeader(color: ASDKColors.Foreground.negativeAccent)
    }

    func activateCVCField() {
        cvcField.becomeFirstResponder()
    }

    func deactivateCVCField() {
        cvcField.resignFirstResponder()
    }
}

// MARK: - MaskedTextFieldDelegateListener

extension SavedCardView: MaskedTextFieldDelegateListener {
    func textField(_ textField: UITextField, didFillMask complete: Bool, extractValue value: String) {
        presenter?.savedCardView(didChangeCVC: value)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter?.savedCardViewDidBeginCVCFieldEditing()
    }
}
