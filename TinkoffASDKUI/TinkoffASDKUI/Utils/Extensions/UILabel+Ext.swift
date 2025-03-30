//
//  UILabel+Ext.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 28.12.2022.
//

import UIKit

extension UILabel {
    func isTextFitsBounds() -> Bool {
        attributedText?.fitsIn(size: rectForText().size, font: minimumAdjustedFont, numberOfLines: numberOfLines) ?? true
    }

    var minimumAdjustedFont: UIFont {
        guard adjustsFontSizeToFitWidth, minimumScaleFactor > 0 else {
            return font
        }

        return font.withSize(font.pointSize * minimumScaleFactor)
    }

    func rectForText() -> CGRect {
        textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    }
}
