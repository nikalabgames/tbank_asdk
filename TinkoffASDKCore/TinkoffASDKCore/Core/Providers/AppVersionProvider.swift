//
//  AppVersionProvider.swift
//  ASDKSample
//
//  Created by Sergey Galagan on 20.09.2024.
//  Copyright © 2024 Tinkoff. All rights reserved.
//

import Foundation

final class AppVersionProvider: IStringProvider {
    let value: String

    init?(version: String?) {
        guard let version else { return nil }
        value = version
    }
}
