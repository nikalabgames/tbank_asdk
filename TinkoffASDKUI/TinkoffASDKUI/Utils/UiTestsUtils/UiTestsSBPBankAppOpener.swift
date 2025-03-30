//
//  UiTestsSBPBankAppOpener.swift
//  TinkoffASDKUI
//
//  Created by Gleb on 06.05.2024.
//

import Foundation
import TinkoffASDKCore

class UiTestsSBPBankAppOpener: ISBPBankAppOpener {
    func openBankApp(url: URL, _ bank: SBPBank, completion: @escaping SBPBankAppCheckerOpenBankAppCompletion) {
        completion(true)
    }
}
