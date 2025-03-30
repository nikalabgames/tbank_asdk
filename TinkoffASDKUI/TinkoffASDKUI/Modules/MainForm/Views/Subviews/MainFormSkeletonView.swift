//
//  MainFormSkeletonView.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 14.01.2025.
//

import UIKit

/// Отображает скелет экрана `MainFormViewController` пока идет загрузка данных из сети
/// При отрисовке сразу запускает анимацию
/// - Important: Не забывайте деаллоцировать из памяти
final class MainFormSkeletonView: UIView {

    /// Высота вью из макетов дизайна
    static let estimatedHeight: CGFloat = 428

    // Subviews
    private lazy var maskingView = SkeletonView()

    private lazy var bankLogoView = SkeletonView()
    private lazy var titleView = SkeletonView()
    private lazy var totalSumView = SkeletonView()
    private lazy var mainPayMethodView = SkeletonView()
    private lazy var bankLogo = SkeletonView()
    private lazy var emailView = SkeletonView()

    // First cell
    private lazy var firstCellAvatarView = SkeletonView()
    private lazy var firstCellTitleView = SkeletonView()
    private lazy var firstCellSubtitleView = SkeletonView()

    // Second cell
    private lazy var secondCellAvatarView = SkeletonView()
    private lazy var secondCellTitleView = SkeletonView()
    private lazy var secondCellSubtitleView = SkeletonView()

    private let avatarHeight: CGFloat = 40
    private let skeletonModel = SkeletonView.Model(
        color: ASDKColors.Foreground.skeleton,
        cornerRadius: 4
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        startWaterfallAnimation()
    }

    private func skeletonViews() -> [SkeletonView] {
        return [
            bankLogoView,
            titleView,
            totalSumView,
            mainPayMethodView,
            bankLogo,
            emailView,
            firstCellAvatarView,
            firstCellTitleView,
            firstCellSubtitleView,
            secondCellAvatarView,
            secondCellTitleView,
            secondCellSubtitleView,
        ]
    }

    private func setupViews() {
        addSubview(maskingView)
        maskingView.translatesAutoresizingMaskIntoConstraints = false
        maskingView.makeEqualToSuperview()

        let skeletonViews = skeletonViews()

        for skeletonView in skeletonViews {
            skeletonView.configure(model: skeletonModel)
            skeletonView.translatesAutoresizingMaskIntoConstraints = false
            maskingView.addSubview(skeletonView)
            if skeletonView === firstCellAvatarView || skeletonView === secondCellAvatarView {
                var model = skeletonModel
                model.cornerRadius = avatarHeight / 2
                skeletonView.configure(model: model)
            }
        }

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(mainConstraints() + firstCellConstraints() + secondCellConstraints())
    }

    private func mainConstraints() -> [NSLayoutConstraint] {
        [
            bankLogoView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            bankLogoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            bankLogoView.height(constant: 29),
            bankLogoView.width(constant: 115),

            titleView.topAnchor.constraint(equalTo: bankLogoView.bottomAnchor, constant: 41)
                .with(priority: .defaultLow),
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.height(constant: 14),
            titleView.width(constant: 72),

            totalSumView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            totalSumView.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalSumView.height(constant: 31),
            totalSumView.width(constant: 144),

            mainPayMethodView.topAnchor.constraint(equalTo: totalSumView.bottomAnchor, constant: 37)
                .with(priority: .defaultLow),
            mainPayMethodView.leftAnchor.constraint(equalTo: bankLogoView.leftAnchor),
            mainPayMethodView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            mainPayMethodView.height(constant: 56),

            emailView.topAnchor.constraint(equalTo: mainPayMethodView.bottomAnchor, constant: 38)
                .with(priority: .defaultLow),
            emailView.leftAnchor.constraint(equalTo: bankLogoView.leftAnchor),
            emailView.width(constant: 275),
            emailView.height(constant: 18),
        ]
    }

    private func firstCellConstraints() -> [NSLayoutConstraint] {
        [
            firstCellAvatarView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 24)
                .with(priority: .defaultLow),
            firstCellAvatarView.leftAnchor.constraint(equalTo: bankLogoView.leftAnchor),
            firstCellAvatarView.width(constant: avatarHeight),
            firstCellAvatarView.height(constant: avatarHeight),

            firstCellTitleView.topAnchor.constraint(equalTo: firstCellAvatarView.topAnchor, constant: 3)
                .with(priority: .defaultLow),
            firstCellTitleView.leftAnchor.constraint(equalTo: firstCellAvatarView.rightAnchor, constant: 16),
            firstCellTitleView.height(constant: 14),
            firstCellTitleView.width(constant: 102),

            firstCellSubtitleView.topAnchor.constraint(equalTo: firstCellTitleView.bottomAnchor, constant: 11)
                .with(priority: .defaultLow),
            firstCellSubtitleView.leftAnchor.constraint(equalTo: firstCellTitleView.leftAnchor),
            firstCellSubtitleView.height(constant: 10),
            firstCellSubtitleView.width(constant: 158),
        ]
    }

    private func secondCellConstraints() -> [NSLayoutConstraint] {
        [
            secondCellAvatarView.topAnchor.constraint(equalTo: firstCellAvatarView.bottomAnchor, constant: 16)
                .with(priority: .defaultLow),
            secondCellAvatarView.leftAnchor.constraint(equalTo: bankLogoView.leftAnchor),
            secondCellAvatarView.height(constant: avatarHeight),
            secondCellAvatarView.width(constant: avatarHeight),

            secondCellTitleView.topAnchor.constraint(equalTo: secondCellAvatarView.topAnchor, constant: 3)
                .with(priority: .defaultLow),
            secondCellTitleView.leftAnchor.constraint(equalTo: secondCellAvatarView.rightAnchor, constant: 16),
            secondCellTitleView.height(constant: 14),
            secondCellTitleView.width(constant: 102),

            secondCellSubtitleView.topAnchor.constraint(equalTo: secondCellTitleView.bottomAnchor, constant: 11)
                .with(priority: .defaultLow),
            secondCellSubtitleView.leftAnchor.constraint(equalTo: secondCellTitleView.leftAnchor),
            secondCellSubtitleView.height(constant: 10),
            secondCellSubtitleView.width(constant: 158),
        ]
    }

    /// Сначала запускаю анимацию у элементов которые не пересекаются горизонтально
    /// Такие элементы находятся в `verticalSkeletonViews`
    ///
    /// Далее отдельно запускаю анимации для ячеек
    /// Ячейка должна анимироваться как единое целое
    /// Поэтому все элементы одной ячейки имеют один и тот же индекс
    ///
    /// Как итог нет рассинхрона анимации
    private func startWaterfallAnimation() {
        let delay: Double = .waterfallDelay
        let verticalSkeletonViews = [
            bankLogoView,
            titleView,
            totalSumView,
            mainPayMethodView,
            bankLogo,
            emailView,
        ]

        verticalSkeletonViews.enumerated().forEach { index, skeletonView in
            skeletonView.startSkeletonAnimation(
                type: .waterfall(index: CGFloat(index), delay: delay)
            )
        }

        let firstCellIndex = verticalSkeletonViews.count
        let firstCellSkeletonViews = [
            firstCellAvatarView,
            firstCellTitleView,
            firstCellSubtitleView,
        ]

        for skeletonView in firstCellSkeletonViews {
            skeletonView.startAnimating(animationType: .waterfall(index: CGFloat(firstCellIndex), delay: delay))
        }

        let secondCellSkeletonViews = [
            secondCellAvatarView,
            secondCellTitleView,
            secondCellSubtitleView,
        ]

        for skeletonView in secondCellSkeletonViews {
            skeletonView.startAnimating(animationType: .waterfall(index: CGFloat(firstCellIndex + 1), delay: delay))
        }
    }
}

private extension Double {
    static let waterfallDelay: Double = 0.2
}
