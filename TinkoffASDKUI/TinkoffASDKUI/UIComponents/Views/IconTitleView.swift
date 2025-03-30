//
//  IconTitleView.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 15.12.2022.
//

import UIKit

final class IconTitleView: UIView {

    typealias Cell = CollectionCell<IconTitleView>

    private(set) var configuration: Configuration = .empty

    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel.intrinsicContentSize
        var size = CGSize.zero
        let imageHeight = iconImageView.image == nil ? Double.zero : configuration.iconSize.height
        let imageWidth = iconImageView.image == nil ? Double.zero : configuration.iconSize.width
        size.width += imageWidth + configuration.spacing + configuration.contentInsets.horizontal
        size.width += labelSize.width
        size.height = max(imageHeight, labelSize.height) + configuration.contentInsets.vertical
        return size
    }

    // UI

    private let contentView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    private lazy var leftLabelConstraintHasImage = titleLabel.leftAnchor
        .constraint(equalTo: iconImageView.rightAnchor, constant: .zero)
    private lazy var leftLabelConstraintNoImage = titleLabel.leftAnchor
        .constraint(equalTo: contentView.leftAnchor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupViews() {
        addSubview(contentView)
        contentView.clipsToBounds = true
        contentView.makeEqualToSuperview()

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        iconImageView.makeConstraints { view in
            view.size(.zero) +
                [
                    view.topAnchor.constraint(equalTo: view.forcedSuperview.topAnchor).with(priority: .defaultLow),
                    view.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).with(priority: .defaultHigh),
                    view.leftAnchor.constraint(equalTo: view.forcedSuperview.leftAnchor),
                    view.bottomAnchor.constraint(equalTo: view.forcedSuperview.bottomAnchor).with(priority: .defaultLow),
                ]
        }

        titleLabel.makeConstraints { view in
            [
                view.topAnchor.constraint(equalTo: view.forcedSuperview.topAnchor, constant: 3),
                view.rightAnchor.constraint(equalTo: view.forcedSuperview.rightAnchor),
                view.bottomAnchor.constraint(
                    equalTo: view.forcedSuperview.bottomAnchor,
                    constant: -3
                ),
            ]
        }
    }

    private func getHeight() -> CGFloat {
        let verticalInsets = configuration.contentInsets.vertical
        let iconHeight = configuration.iconSize.height
        return verticalInsets + iconHeight
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let targetWidth: Double = intrinsicContentSize.width > size.width ? size.width : intrinsicContentSize.width
        var size = systemLayoutSizeFitting(
            CGSize(width: targetWidth, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        size.height = max(configuration.iconSize.height, size.height)
        return size
    }
}

extension IconTitleView: ConfigurableItem {

    func configure(with configuration: Configuration) {
        let hasImage = configuration.icon.image != nil
        self.configuration = configuration
        updateConstraintInsets(hasImage: hasImage)
        frame.size.height = getHeight()
        iconImageView.configure(with: configuration.icon)
        iconImageView.isHidden = !hasImage
        titleLabel.configure(configuration.title)
    }

    private func updateConstraintInsets(hasImage: Bool) {
        leftLabelConstraintHasImage.isActive = hasImage
        leftLabelConstraintNoImage.isActive = !hasImage

        contentView.constraintUpdater.updateEdgeInsets(insets: configuration.contentInsets)

        iconImageView.parsedConstraints.forEach { parsedConstraint in
            switch parsedConstraint.kind {
            case .height:
                parsedConstraint.constraint.constant = configuration.iconSize.height
            case .width:
                parsedConstraint.constraint.constant = configuration.iconSize.width
            default:
                break
            }
        }

        titleLabel.parsedConstraints.forEach { parsedConstraint in
            switch parsedConstraint.kind {
            case .left where hasImage:
                parsedConstraint.constraint.constant = configuration.spacing
            default:
                break
            }
        }
    }
}

extension IconTitleView: Configurable, Reusable {

    func update(with configuration: Configuration) {
        configure(with: configuration)
    }

    func prepareForReuse() {}
}

extension IconTitleView {

    struct Configuration {
        let icon: UIImageView.Configuration
        let title: UILabel.Configuration
        var iconSize: CGSize
        var spacing: CGFloat
        var contentInsets: UIEdgeInsets

        static func buildAddCardButton(icon: UIImage?, text: String?) -> Self {
            Self(
                icon: UIImageView.Configuration(image: icon, contentMode: .scaleAspectFit),
                title: UILabel.Configuration(content: .plain(text: text, style: .bodyL())),
                iconSize: CGSize(width: 40, height: 40),
                spacing: 16,
                contentInsets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            )
        }

        static func snackBarConfiguration(icon: UIImage?, text: String?) -> Self {
            var config = Self.buildAddCardButton(icon: icon, text: text)
            config.spacing = 8
            config.contentInsets = .zero
            config.contentInsets.right = 4
            config.iconSize = CGSize(width: 24, height: 24)
            return config
        }

        static var empty: Self {
            Self(
                icon: .empty,
                title: .empty,
                iconSize: .zero,
                spacing: .zero,
                contentInsets: .zero
            )
        }
    }
}
