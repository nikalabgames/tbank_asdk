//
//  ITextAndImageHeaderViewOutput.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 08.02.2023.
//

import Foundation

protocol ITextAndImageHeaderViewOutput: AnyObject, Equatable {
    var view: ITextAndImageHeaderViewInput? { get set }

    func copy() -> any ITextAndImageHeaderViewOutput
}
