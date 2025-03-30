//
//  LoaderTitleView.swift
//  popup
//
//  Created by Ivan Glushko on 21.11.2022.
//

import UIKit

final class LoaderTitleView: UIView {

    override var intrinsicContentSize: CGSize {
        var labelSize = titleLabelView.intrinsicContentSize
        labelSize.width += Constants.Loader.size.width
        labelSize.width += (Constants.Loader.inset) + Constants.Label.leftInset + Constants.Label.rightInset
        return labelSize
    }

    // MARK: - UI

    let loaderHolderView = UIView()
    let titleLabelView = UILabel()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let targetWidth: Double = intrinsicContentSize.width > size.width ? size.width : intrinsicContentSize.width
        return systemLayoutSizeFitting(
            CGSize(width: targetWidth, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupViews() {
        backgroundColor = .clear
        loaderHolderView.backgroundColor = .clear

        addSubview(loaderHolderView)
        addSubview(titleLabelView)

        loaderHolderView.makeConstraints { make in
            [
                make.centerYAnchor.constraint(equalTo: titleLabelView.centerYAnchor),
                make.leftAnchor.constraint(equalTo: make.forcedSuperview.leftAnchor, constant: Constants.Loader.inset),
            ] + make.size(Constants.Loader.size)
        }

        titleLabelView.makeConstraints { make in
            [
                make.topAnchor.constraint(equalTo: make.forcedSuperview.topAnchor, constant: Constants.Loader.inset),
                make.leftAnchor.constraint(equalTo: loaderHolderView.rightAnchor, constant: Constants.Label.leftInset),
                make.rightAnchor.constraint(equalTo: make.forcedSuperview.rightAnchor, constant: -Constants.Label.rightInset),
                make.bottomAnchor.constraint(
                    equalTo: make.forcedSuperview.bottomAnchor,
                    constant: -Constants.Loader.inset
                ).with(priority: .defaultLow),
            ]
        }
    }
}
