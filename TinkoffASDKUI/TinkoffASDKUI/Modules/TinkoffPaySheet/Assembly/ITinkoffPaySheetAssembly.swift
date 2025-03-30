//
//  ITinkoffPaySheetAssembly.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 13.03.2023.
//

import UIKit

protocol ITinkoffPaySheetAssembly {
    func tinkoffPaySheet(paymentFlow: PaymentFlow, completion: PaymentResultCompletion?) -> UIViewController
}
