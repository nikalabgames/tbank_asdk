//
//  IMainFormOrderDetailsViewOutput.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 08.02.2023.
//

import Foundation

protocol IMainFormOrderDetailsViewOutput: AnyObject, Equatable {
    var view: IMainFormOrderDetailsViewInput? { get set }

    func copy() -> any IMainFormOrderDetailsViewOutput
}
