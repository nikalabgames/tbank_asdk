//
//  TDSSpinnerProducer.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 05.04.2024.
//

import TdsSdkIos
import UIKit

/// Поставляет спиннер / лоадер вью для 3дс транзакция через App Based Flow
final class TDSSpinnerProducer: SpinnerProducerProtocol {

    /// Создаем 1 сущность, чтобы избежать, не удаленных с экрана SpinnerView
    private let spinnerView = TDSSpinnerView()

    func getSpinner(_ hudedController: UIViewController) -> ExternalProgressDialog {
        spinnerView.setHudedViewController(hudedController)
        return spinnerView
    }
}

/// Вью лоадер для 3дс тразанкции через App Based Flow
private final class TDSSpinnerView: UIView, ExternalProgressDialog {
    static let tag = 7778

    private let activityIndicatorView: ActivityIndicatorView
    private lazy var viewHolder = ViewHolder(base: activityIndicatorView)

    var hudedController: UIViewController

    init() {
        var style = ActivityIndicatorView.Style.standart
        style.lineColor = ASDKColors.Foreground.brandTinkoffAccent
        activityIndicatorView = ActivityIndicatorView(style: style)
        hudedController = UIViewController()
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // do nothing
        // Блокируем user interaction
    }

    func setHudedViewController(_ controller: UIViewController) {
        hudedController = controller
    }

    func internalStartAnimating() {
        activityIndicatorView.startAnimation(animated: true)
    }

    func internalStopAnimating() {
        activityIndicatorView.stopAnimation(animated: true)
    }

    func start() {
        tag = Self.tag
        UIView.animateAddSubview(self, at: hudedController.view)
        makeEqualToSuperviewToSafeArea()
        internalStartAnimating()
    }

    func stop() {
        internalStopAnimating()
        if let viewToRemove = hudedController.view.viewWithTag(Self.tag) {
            UIView.animateRemoveFromSuperview(for: viewToRemove)
        }
    }

    // MARK: - Private

    private func setupViews() {
        addSubview(viewHolder)
        let size = 55 as CGFloat
        viewHolder.dropShadow(with: .medium)
        viewHolder.backgroundColor = ASDKColors.Background.elevation2.color
        viewHolder.layer.cornerRadius = 11
        viewHolder.makeConstraints { view in
            view.makeCenterEqualToSuperview() + [
                view.height(constant: size),
                view.width(constant: size),
            ]
        }
    }
}
