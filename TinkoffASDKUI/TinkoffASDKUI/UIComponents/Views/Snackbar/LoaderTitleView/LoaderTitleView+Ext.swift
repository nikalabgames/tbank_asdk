//
//  LoaderTitleView+Ext.swift
//  popup
//
//  Created by Ivan Glushko on 21.11.2022.
//

import UIKit

extension LoaderTitleView: ActivityIndicatorDisplayable {

    /// Показать индикатор
    func showActivityIndicator(with style: ActivityIndicatorView.Style) {
        let activityIndicatorView = ActivityIndicatorView(style: style)
        activityIndicatorView.transform = CGAffineTransform(scaleX: .zero, y: .zero)

        let container = ViewHolder(base: activityIndicatorView)

        loaderHolderView.addSubview(container)
        container.makeEqualToSuperview()

        UIView.animate(withDuration: .scaleDuration) {
            activityIndicatorView.transform = .identity
        }

        activityIndicatorView.startAnimation(animated: true)
    }

    /// Скрыть индикатор
    func hideActivityIndicator() {
        let container = loaderHolderView.subviews.compactMap { $0 as? ViewHolder<ActivityIndicatorView> }.first
        let indicatorView = container?.base
        UIView.animate(withDuration: .scaleDuration, animations: {
            indicatorView?.alpha = .zero
        }, completion: { _ in
            container?.removeFromSuperview()
        })
    }
}

extension LoaderTitleView: Animatable {

    func configure(_ config: Configuration) {
        titleLabelView.configure(config.title)
        startAnimating()
    }

    func startAnimating() {
        stopAnimating()
        showActivityIndicator(with: .tinkoffYellowSmall)
    }

    func stopAnimating() {
        hideActivityIndicator()
    }
}

extension LoaderTitleView {

    struct Constants {

        struct Loader {
            static let size = CGSize(width: 24, height: 24)
            static let inset: CGFloat = 3
        }

        struct Label {
            static let leftInset: CGFloat = 8
            static let rightInset: CGFloat = 4
        }
    }
}

extension LoaderTitleView {

    final class Configuration {
        let title: UILabel.Configuration

        init(title: UILabel.Configuration) {
            self.title = title
        }
    }
}

private extension ActivityIndicatorView.Style {

    static var tinkoffYellowSmall: Self {
        ActivityIndicatorView.Style(
            lineColor: ASDKColors.Foreground.brandTinkoffAccent,
            diameter: 24
        )
    }
}
