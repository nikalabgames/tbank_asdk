//
//  IQrImageViewInput.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 14.03.2023.
//

protocol IQrImageViewInput: AnyObject {
    func set(qrCodeHTML: String)
    func set(qrCodeUrl: String)
}
