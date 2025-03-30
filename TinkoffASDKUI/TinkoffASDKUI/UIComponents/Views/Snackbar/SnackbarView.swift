//
//  SnackbarView.swift
//  popup
//
//  Created by Ivan Glushko on 17.11.2022.
//

import UIKit

/// Показывает бабл с информацией внутри. Умеет презентоваться сверху вниз.
final class SnackbarView: UIView {

    /// Стандартный размер снекбара
    static var defaultSize: CGSize { Constants.defaultSize }

    /// Время показа снек бара по дефолту
    static let showTimeInterval: Double = 5

    private let contentView = UIView()

    private var shadowStyle: ShadowStyle?

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAccessibilityIdentifier()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        userInterfaceThemeDidChange(style: UIScreen.main.traitCollection.userInterfaceStyle)
    }

    // MARK: - Public

    func hide() {
        removeFromSuperview()
    }

    // MARK: - Private

    private func setupViews() {
        contentView.clipsToBounds = true
        addSubview(contentView)
        contentView.makeEqualToSuperview()
    }

    private func setupAccessibilityIdentifier() {
        accessibilityIdentifier = AsdkAccessibilityIdentifier.snackBarView
    }
}

extension SnackbarView {

    func configure(with config: Configuration) {
        prepareForReuse()
        configureSnack(style: config.style)
        configureSnack(data: config.content)
        config.onDidConfigure?()
    }

    private func configureSnack(style: Style) {
        layer.masksToBounds = false
        layer.cornerRadius = style.cornerRadius
        contentView.layer.cornerRadius = style.cornerRadius
        contentView.backgroundColor = style.backgroundColor
        shadowStyle = style.shadow
        applyShadow(for: UIScreen.main.traitCollection.userInterfaceStyle)
    }

    private func applyShadow(for style: UIUserInterfaceStyle?) {
        guard let style = style else { return }
        switch style {
        case .dark:
            removeShadow()
        default:
            if let shadowStyle = shadowStyle {
                dropShadow(with: shadowStyle)
            }
        }
    }

    private func userInterfaceThemeDidChange(style: UIUserInterfaceStyle) {
        applyShadow(for: style)
    }

    private func configureSnack(data: Content) {
        switch data {
        case let .view(subContentView, insets):
            contentView.addSubview(subContentView)
            subContentView.makeEqualToSuperview(insets: insets)
        case let .loader(config):
            let loaderView = LoaderTitleView()
            configureSnack(data: .view(contentView: loaderView, insets: Constants.contentInsets))
            loaderView.configure(config)
        case let .iconTitle(icon, text):
            let view = IconTitleView()
            configureSnack(data: .view(contentView: view, insets: Constants.contentInsets))
            view.configure(with: .snackBarConfiguration(icon: icon, text: text))
        case .none:
            break
        }
    }

    private func prepareForReuse() {
        removeShadow()
        backgroundColor = nil
        layer.cornerRadius = .zero
        contentView.layer.cornerRadius = .zero
        contentView.backgroundColor = .clear
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var modifiedSize = size
        modifiedSize.width -= Constants.contentInsets.horizontal
        modifiedSize.height -= Constants.contentInsets.vertical
        guard let subview = contentView.subviews.first else { return .zero }
        var calculatedSize = subview.sizeThatFits(modifiedSize)
        calculatedSize.width += Constants.contentInsets.horizontal
        calculatedSize.height += Constants.contentInsets.vertical
        return calculatedSize
    }

    func getSize() -> CGSize {
        var windowsSize = UIScreen.main.bounds.size
        windowsSize.width -= 16 * 2 // минус отступы слева и справа по 16
        return sizeThatFits(windowsSize)
    }
}

extension SnackbarView {

    enum State {
        case hidden
        case shown
    }

    struct Constants {
        static let anchorInset: CGFloat = 24
        static let defaultSize = CGSize(width: UIScreen.main.bounds.width - (2 * 16), height: 48)
        static let contentInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}

extension SnackbarView {

    struct Configuration {
        let content: Content
        let style: Style

        var onDidConfigure: (() -> Void)?
    }

    enum Content {
        case view(contentView: UIView, insets: UIEdgeInsets = .zero)
        case loader(configuration: LoaderTitleView.Configuration)
        case iconTitle(icon: UIImage?, text: String?)
        case none
    }

    struct Style {
        var backgroundColor: UIColor?
        let cornerRadius: CGFloat
        let shadow: ShadowStyle?

        func set(backgroundColor: UIColor?) -> Self {
            var shadowCopy = self
            shadowCopy.backgroundColor = backgroundColor
            return shadowCopy
        }

        static var base: Self {
            Self(
                backgroundColor: ASDKColors.Background.elevation3.color,
                cornerRadius: 24,
                shadow: .medium
            )
        }
    }
}
