//
//  FloatingTextField.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 31.01.2023.
//

import UIKit

final class FloatingTextField: UIView {

    // MARK: Dependencies

    weak var delegate: FloatingTextFieldDelegate?

    // MARK: Properties

    private var insetsType: InsetsType

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ASDKColors.Background.neutral1.color
        view.layer.cornerRadius = .containerViewRadius
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.contentVerticalAlignment = .bottom
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = ASDKColors.Text.secondary.color
        label.numberOfLines = 1
        label.accessibilityIdentifier = AsdkAccessibilityIdentifier.headerLabel
        return label
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        return gesture
    }()

    // MARK: Initialization

    init(insetsType: InsetsType = .commonInsets) {
        self.insetsType = insetsType
        super.init(frame: .zero)
        setupViews()
        setupViewsConstraints()
    }

    override init(frame: CGRect) {
        insetsType = .commonInsets
        super.init(frame: .zero)
        setupViews()
        setupViewsConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    override var isFirstResponder: Bool {
        textField.isFirstResponder
    }
}

// MARK: - Public

extension FloatingTextField {
    func setContainerView(radius: CGFloat) {
        containerView.layer.cornerRadius = radius
    }

    func set(text: String?, animated: Bool) {
        textField.text = text
        liftHeaderLabelIfNeeded(animated: animated)
    }

    func set(text: String?) {
        set(text: text, animated: true)
    }

    func set(placeholder: String) {
        textField.placeholder = placeholder
        if textField.text?.isEmpty == true {
            textField.setPlaceholder(color: .clear)
        }
    }

    func set(clearButtonMode: UITextField.ViewMode) {
        textField.clearButtonMode = clearButtonMode
    }

    func set(rightView: UIView) {
        textField.rightView = rightView
    }

    func set(rightViewMode: UITextField.ViewMode) {
        textField.rightViewMode = rightViewMode
    }

    func set(contentType: UITextContentType) {
        textField.textContentType = contentType
    }

    func set(keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }

    func set(isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }

    func setHeader(text: String, animated: Bool) {
        headerLabel.text = text
        liftHeaderLabelIfNeeded(animated: animated)
    }

    func setHeader(text: String) {
        setHeader(text: text, animated: true)
    }

    func setHeader(color: UIColor) {
        animateChanges(in: headerLabel, animations: { self.headerLabel.textColor = color })
    }
}

// MARK: - UITextFieldDelegate

extension FloatingTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldBeginEditing(textField) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        liftHeaderLabel(animated: true)
        delegate?.textFieldDidBeginEditing(textField)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldEndEditing(textField) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            downHeaderLabel()
        }
        delegate?.textFieldDidEndEditing(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn(textField) ?? true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldClear(textField) ?? true
    }
}

// MARK: - Actions

extension FloatingTextField {
    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }

    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        delegate?.textField(textField, didChangeTextTo: textField.text ?? "")
    }
}

// MARK: - Private

extension FloatingTextField {
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(headerLabel)
    }

    private func setupViewsConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: insetsType.textFieldInsets.left),
            textField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -insetsType.textFieldInsets.right),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: insetsType.textFieldInsets.top),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -insetsType.textFieldInsets.bottom),

            headerLabel.leftAnchor.constraint(equalTo: textField.leftAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
        ])
    }

    private func liftHeaderLabel(animated: Bool) {
        if animated {
            animateHeaderLabel(isLifting: true)
        } else {
            UIView.performWithoutAnimation {
                animateHeaderLabel(isLifting: true)
            }
        }
    }

    private func downHeaderLabel() {
        animateHeaderLabel(isLifting: false)
    }

    private func animateHeaderLabel(isLifting: Bool) {
        let placeholderColor: UIColor = isLifting ? ASDKColors.Text.tertiary.color : .clear

        let headerWidth = headerLabel.intrinsicContentSize.width
        let headerLiftedX: Double = (headerWidth - (headerWidth * .headerLabelLiftedScale)) / 2.0
        let headerLabelXTranslation: Double = isLifting ? -headerLiftedX : .zero
        let headerLabelYTranslation: Double = isLifting ? -.headerLabelLiftingTranslationY : .zero

        let headerLabelScale: CGFloat = isLifting ? .headerLabelLiftedScale : .headerLabelDownScale

        let translationTransform = CGAffineTransform(translationX: headerLabelXTranslation, y: headerLabelYTranslation)
        let scaleTransform = CGAffineTransform(scaleX: headerLabelScale, y: headerLabelScale)
        let allTransforms = scaleTransform.concatenating(translationTransform)

        UIView.animate(withDuration: .defaultAnimationDuration) {
            self.headerLabel.transform = allTransforms
        }

        animateChanges(in: textField, animations: { self.textField.setPlaceholder(color: placeholderColor) })
    }

    private func liftHeaderLabelIfNeeded(animated: Bool) {
        if textField.text?.isEmpty == false { liftHeaderLabel(animated: animated) }
    }

    private func animateChanges(in view: UIView, animations: @escaping VoidBlock) {
        UIView.transition(
            with: view,
            duration: .defaultAnimationDuration,
            options: .transitionCrossDissolve,
            animations: animations,
            completion: nil
        )
    }
}

// MARK: - Constants

extension FloatingTextField {
    enum InsetsType {
        case commonInsets
        case commonAndHugeLeftInset
        case smallInsets

        var textFieldInsets: UIEdgeInsets {
            switch self {
            case .commonInsets: return UIEdgeInsets(top: 9, left: 12, bottom: 9, right: 7)
            case .commonAndHugeLeftInset: return UIEdgeInsets(top: 9, left: 64, bottom: 9, right: 7)
            case .smallInsets: return UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 7)
            }
        }
    }
}

private extension Double {
    static let headerLabelLiftingTranslationY: Double = 10
}

private extension CGFloat {
    static let headerLabelLiftedScale: CGFloat = 0.8
    static let headerLabelDownScale: CGFloat = 1

    static let containerViewRadius: CGFloat = 16
}
