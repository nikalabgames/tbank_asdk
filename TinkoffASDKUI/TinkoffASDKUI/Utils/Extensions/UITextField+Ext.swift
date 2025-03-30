//
//  UITextField+Ext.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 31.01.2023.
//

import UIKit

extension UITextField {
    func setPlaceholder(color: UIColor) {
        let placeholderText = placeholder ?? ""
        // Фикс краша для simulator (intel/rosseta)
        #if targetEnvironment(simulator) && arch(x86_64)
            attributedPlaceholder = NSAttributedString(string: placeholderText)
        #else
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: color])
        #endif
    }
}
