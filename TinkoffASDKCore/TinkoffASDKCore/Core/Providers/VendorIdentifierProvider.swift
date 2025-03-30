//
//  VendorIdentifierProvider.swift
//  TinkoffASDKCore
//
//  Created by Ivan Glushko on 15.07.2024.
//

import Foundation
import UIKit.UIDevice

/// Отдает user id
struct VendorIdentifierProvider: IStringProvider {
    let value: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
}
