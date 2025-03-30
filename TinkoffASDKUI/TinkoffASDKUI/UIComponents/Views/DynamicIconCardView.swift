//
//  DynamicIconCardView.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 11.11.2022.
//

import UIKit

/// Умеет показывать подложку для карты / карту с изображением банка и платежной системы
/// Адаптивен под изменении цветовой темы (light/dark)
class DynamicIconCardView: UIView {

    override var intrinsicContentSize: CGSize { frame.size }
    override var center: CGPoint {
        didSet { setupFrames() }
    }

    private let cardImageView = UIImageView()
    private let paymentSystemBadgeView = UIView()
    private let paymentSystemBadgeImageView = UIImageView()

    // State

    private var constants = Constants()

    // MARK: - Init

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    // MARK: - Public

    func configure(model: Model) {
        configureWithStyle(model.style)

        let animations = {
            self.configureWithData(model.data)
        }

        if model.style.enableAnimations {
            UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseInOut) {
                animations()
            }
        } else {
            animations()
        }
    }

    func clear() {
        configure(model: Model(data: Data()))
    }

    // MARK: - Private

    private func setupViews() {
        addSubview(cardImageView)
        addSubview(paymentSystemBadgeView)
        addSubview(paymentSystemBadgeImageView)

        cardImageView.contentMode = .scaleAspectFill
        cardImageView.clipsToBounds = true
        paymentSystemBadgeImageView.contentMode = .scaleAspectFit
        paymentSystemBadgeImageView.clipsToBounds = true

        setupFrames()
        setupAccessabilityIdentifier()
    }

    private func setupFrames() {
        cardImageView.frame = bounds
        paymentSystemBadgeView.frame = CGRect(
            origin: CGPoint(
                x: cardImageView.frame.maxX - constants.badgeView.inset - constants.badgeView.size.width,
                y: cardImageView.frame.maxY - constants.badgeView.inset - constants.badgeView.size.height
            ),
            size: constants.badgeView.size
        )

        paymentSystemBadgeImageView.frame = CGRect(
            origin: CGPoint(
                x: cardImageView.frame.maxX - constants.badgeImageView.size.width - constants.badgeImageView.inset,
                y: cardImageView.frame.maxY - constants.badgeImageView.size.height
            ),
            size: constants.badgeImageView.size
        )
    }

    private func configureWithStyle(_ style: Style) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        cardImageView.layer.cornerRadius = style.cornerRadius

        paymentSystemBadgeView.layer.cornerRadius = style.paymentSystemBadgeCornerRadius
        paymentSystemBadgeView.backgroundColor = style.paymentSystemBadgeBackgroundColor
    }

    private func configureWithData(_ data: Data) {
        configureBank(icon: data.bank)
        configurePaymentSystem(icon: data.paymentSystem, bank: data.bank)
        setupAccessabilityLabels(data)
    }

    private func configureBank(icon: Icon.Bank?) {
        guard cardImageView.image != icon?.image else { return }
        cardImageView.alpha = icon == nil ? 0 as CGFloat : 1 as CGFloat
        cardImageView.image = icon?.image
    }

    private func configurePaymentSystem(icon: Icon.PaymentSystem?, bank: Icon.Bank?) {
        paymentSystemBadgeView.alpha = icon == nil ? 1 as CGFloat : 0 as CGFloat
        paymentSystemBadgeImageView.alpha = icon == nil ? 0 as CGFloat : 1 as CGFloat
        paymentSystemBadgeImageView.image = icon?.getImage(bank: bank)
    }

    private func setupAccessabilityLabels(_ data: Data) {
        cardImageView.accessibilityLabel = data.bank == nil ?
            AsdkAccessibilityIdentifier.emptyCardImage : String(describing: data.bank!)

        paymentSystemBadgeView.accessibilityLabel = data.paymentSystem == nil ?
            AsdkAccessibilityIdentifier.emptyPaymentSystemImage : String(describing: data.paymentSystem!)

        paymentSystemBadgeImageView.image?.accessibilityLabel = data.paymentSystem == nil ?
            AsdkAccessibilityIdentifier.emptyPaymentSystemImage : String(describing: data.paymentSystem!)
    }

    private func setupAccessabilityIdentifier() {
        cardImageView.accessibilityIdentifier = AsdkAccessibilityIdentifier.bankIcon
        paymentSystemBadgeView.accessibilityIdentifier = AsdkAccessibilityIdentifier.paymentSystemIcon
    }
}

// MARK: - Constants

extension DynamicIconCardView {

    static var defaultSize: CGSize { Constants.Card().size }

    struct Constants {
        var card = Card()
        var badgeView = BadgeView()
        var badgeImageView = BadgeImageView()

        struct Card {
            var size = CGSize(width: 40, height: 26)
        }

        struct BadgeView {
            var inset: CGFloat = 4
            var size = CGSize(width: 12, height: 7)
        }

        struct BadgeImageView {
            var size = CGSize(width: 13, height: 13)
            var inset: CGFloat = 3
        }
    }
}

// MARK: - Other

protocol IDynamicIconCardViewUpdater: AnyObject {
    func update(config: DynamicIconCardView.Model)
}

extension DynamicIconCardView {

    struct Model {
        var data: Data
        var style = Style()

        weak var updater: IDynamicIconCardViewUpdater?

        init(
            data: Data = Data(),
            style: Style = Style(),
            updater: IDynamicIconCardViewUpdater? = nil
        ) {
            self.data = data
            self.style = style
            self.updater = updater
        }
    }

    struct Data {
        var bank: Icon.Bank?
        var paymentSystem: Icon.PaymentSystem?
    }

    struct Style {
        var enableAnimations = true

        // card
        var cornerRadius: CGFloat = 4
        var backgroundColor = ASDKColors.Background.neutral2.color
        // badge
        var paymentSystemBadgeCornerRadius: CGFloat = 2
        var paymentSystemBadgeBackgroundColor = ASDKColors.Background.neutral2.color
    }

    enum Icon {}
}

// MARK: - Icons

extension DynamicIconCardView.Icon {

    enum Bank: CaseIterable {
        case tinkoff
        case alpha
        case raiffaisen
        case vtb
        case gazprom
        case ozon
        case sber

        case other

        var image: UIImage {
            switch self {
            case .tinkoff:
                return Asset.PaymentCard.Bank.tinkoff.image
            case .alpha:
                return Asset.PaymentCard.Bank.alpha.image
            case .raiffaisen:
                return Asset.PaymentCard.Bank.raiffaisen.image
            case .vtb:
                return Asset.PaymentCard.Bank.vtb.image
            case .gazprom:
                return Asset.PaymentCard.Bank.gazprom.image
            case .ozon:
                return Asset.PaymentCard.Bank.ozon.image
            case .sber:
                return Asset.PaymentCard.Bank.sber.image
            case .other:
                return Asset.PaymentCard.Bank.other.image
            }
        }
    }

    enum PaymentSystem: CaseIterable {
        case mir
        case visa
        case maestro
        case uninonPay
        case masterCard

        enum Style {
            case plain
            case white
        }

        // MARK: - Methods

        func getImage(bank: Bank?) -> UIImage {
            let style = (bank == .raiffaisen || bank == nil) ? Style.plain : Style.white
            return getImage(style: style, bank: bank)
        }

        func getImage(style: Style, bank: Bank?) -> UIImage {
            if #available(iOS 13.0, *), bank == .raiffaisen {
                if let image = handleRaiffassenCase() {
                    return image
                }
            }

            switch self {
            case .mir:
                switch style {
                case .white:
                    return Asset.PaymentCard.PaymentSystem.mirWhite.image
                case .plain:
                    return Asset.PaymentCard.PaymentSystem.mir.image
                }

            case .visa:
                switch style {
                case .white:
                    return Asset.PaymentCard.PaymentSystem.visaWhite.image
                case .plain:
                    return Asset.PaymentCard.PaymentSystem.visa.image
                }
            case .maestro:
                return Asset.PaymentCard.PaymentSystem.maestro.image
            case .uninonPay:
                return Asset.PaymentCard.PaymentSystem.unionpay.image
            case .masterCard:
                return Asset.PaymentCard.PaymentSystem.mastercard.image
            }
        }

        /// Всегда отдаем светлую иконку ПС для райф банка
        private func handleRaiffassenCase() -> UIImage? {
            let lightTrait = UITraitCollection(userInterfaceStyle: .light)
            switch self {
            case .mir:
                let image = Asset.PaymentCard.PaymentSystem.mir.image
                guard let lightImage = image.imageAsset?.image(with: lightTrait),
                      let cgImage = lightImage.cgImage
                else {
                    return image
                }
                return UIImage(cgImage: cgImage)
            case .visa:
                let image = Asset.PaymentCard.PaymentSystem.visa.image
                guard let lightImage = image.imageAsset?.image(with: lightTrait),
                      let cgImage = lightImage.cgImage
                else {
                    return image
                }
                return UIImage(cgImage: cgImage)
            default:
                break
            }

            return nil
        }
    }
}
