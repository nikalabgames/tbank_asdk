//
//  AsdkSuiView.swift
//  TinkoffASDKUI
//
//  Created by Sergey Galagan on 03.07.2024.
//

import SwiftUI
import TinkoffASDKCore
import UIKit

public struct AsdkSuiView: View {
    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public var body: some View {
        ViewControllerRepresentable(content: viewController).ignoreSafeArea()
    }
}
