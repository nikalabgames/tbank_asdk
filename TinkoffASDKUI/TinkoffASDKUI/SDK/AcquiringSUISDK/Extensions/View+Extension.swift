//
//  View+Extension.swift
//  TinkoffASDKUI
//
//  Created by Sergey Galagan on 03.07.2024.
//

import SwiftUI

extension View {
    @inlinable func ignoreSafeArea() -> some View {
        if #available(iOS 14.0, *) {
            return ignoresSafeArea()
        } else {
            return edgesIgnoringSafeArea(.all)
        }
    }
}
