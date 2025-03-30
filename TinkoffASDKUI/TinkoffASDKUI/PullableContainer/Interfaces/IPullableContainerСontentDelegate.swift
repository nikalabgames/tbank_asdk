//
//  IPullableContainerContentDelegate.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 10.04.2023.
//

import Foundation

protocol IPullableContainerContentDelegate: AnyObject {
    func updateHeight(animated: Bool, alongsideAnimation: VoidBlock?, completion: VoidBlock?)
}

extension IPullableContainerContentDelegate {
    func updateHeight(animated: Bool = true) {
        updateHeight(animated: animated, alongsideAnimation: nil, completion: nil)
    }

    func updateHeight(animated: Bool, alongsideAnimation: @escaping VoidBlock) {
        updateHeight(animated: animated, alongsideAnimation: alongsideAnimation, completion: nil)
    }
}
