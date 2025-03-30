//
//  TDSCustomizationBuilder.swift
//  TinkoffASDKUI
//
//  Created by Ivan Glushko on 03.05.2024.
//

import Foundation
import ThreeDSWrapper

protocol ITDSCustomizationBuilder {
    /// Формирует объект с настройками интерфейса для 3дс сдк
    func build() -> ThreeDSWrapper.UiCustomization
}

final class TDSCustomizationBuilder: ITDSCustomizationBuilder {
    private let regularFont = UIFont.systemFont(ofSize: .regularFontSize)
    private let regularFontWeight = UIFont.Weight.regular.rawValue
    private let semiboldFont = UIFont.systemFont(ofSize: .regularFontSize, weight: .semibold)
    private let semiboldFontWeight = UIFont.Weight.semibold.rawValue

    /// Формирует объект с настройками интерфейса для 3дс сдк
    func build() -> ThreeDSWrapper.UiCustomization {
        let customization = ThreeDSWrapper.UiCustomization()
        addLabelCustomization(in: customization)
        addSubmitButtonCustomization(in: customization)
        addResendButtonCustomization(in: customization)
        addVerifyButtonCustomization(in: customization)
        addContinueButtonCustomization(in: customization)
        addNextButtonCustomization(in: customization)
        addCancelButtonCustomization(in: customization)
        addTextBoxCustomization(in: customization)
        addToolbarCustomization(in: customization)
        return customization
    }

    /// Label
    private func addLabelCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let labelCustomization = ThreeDSWrapper.LabelCustomization()
        labelCustomization.setHeadingTextColor(ASDKColors.Text.primary.color)
        labelCustomization.setHeadingTextFontName(semiboldFont.fontName)
        labelCustomization.setHeadingTextFontSize(.headingTextFontSize)
        labelCustomization.setTextColor(ASDKColors.Text.primary.color)
        labelCustomization.setTextFontName(regularFont.fontName)
        labelCustomization.setTextFontSize(Int(regularFont.pointSize))
        customization.setLabelCustomization(labelCustomization)
    }

    /// Submit button
    private func addSubmitButtonCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let buttonCustomization = ThreeDSWrapper.ButtonCustomization()
        buttonCustomization.setBackgroundColor(ASDKColors.Foreground.brandTinkoffAccent)
        buttonCustomization.setCornerRadius(.buttonCornerRadius)
        buttonCustomization.setTextColor(ASDKColors.Text.primary.color)
        buttonCustomization.setTextFontSize(Int(regularFont.pointSize))
        buttonCustomization.setTextFontName(regularFont.fontName)
        customization.setButtonCustomization(buttonCustomization: buttonCustomization, buttonType: .SUBMIT)
    }

    /// Resend button
    private func addResendButtonCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let buttonCustomizationResend = ThreeDSWrapper.ButtonCustomization()
        buttonCustomizationResend.setBackgroundColor(ASDKColors.Foreground.brandTinkoffAccent)
        buttonCustomizationResend.setCornerRadius(.buttonCornerRadius)
        buttonCustomizationResend.setTextColor(ASDKColors.Text.primary.color)
        buttonCustomizationResend.setTextFontSize(Int(regularFont.pointSize))
        buttonCustomizationResend.setTextFontName(regularFont.fontName)
        customization.setButtonCustomization(buttonCustomization: buttonCustomizationResend, buttonType: .RESEND)
    }

    /// Verify button
    private func addVerifyButtonCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let buttonCustomizationVerify = ThreeDSWrapper.ButtonCustomization()
        buttonCustomizationVerify.setBackgroundColor(ASDKColors.Foreground.brandTinkoffAccent)
        buttonCustomizationVerify.setCornerRadius(.buttonCornerRadius)
        buttonCustomizationVerify.setTextColor(ASDKColors.Text.primary.color)
        buttonCustomizationVerify.setTextFontSize(Int(regularFont.pointSize))
        buttonCustomizationVerify.setTextFontName(regularFont.fontName)
        customization.setButtonCustomization(buttonCustomization: buttonCustomizationVerify, buttonType: .VERIFY)
    }

    /// Continue button
    private func addContinueButtonCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let buttonCustomizationContinue = ThreeDSWrapper.ButtonCustomization()
        buttonCustomizationContinue.setBackgroundColor(ASDKColors.Foreground.brandTinkoffAccent)
        buttonCustomizationContinue.setCornerRadius(.buttonCornerRadius)
        buttonCustomizationContinue.setTextColor(ASDKColors.Text.primary.color)
        buttonCustomizationContinue.setTextFontSize(Int(regularFont.pointSize))
        buttonCustomizationContinue.setTextFontName(regularFont.fontName)
        customization.setButtonCustomization(buttonCustomization: buttonCustomizationContinue, buttonType: .CONTINUE)
    }

    /// Next button
    private func addNextButtonCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let buttonCustomizationNext = ThreeDSWrapper.ButtonCustomization()
        buttonCustomizationNext.setBackgroundColor(ASDKColors.Foreground.brandTinkoffAccent)
        buttonCustomizationNext.setCornerRadius(.buttonCornerRadius)
        buttonCustomizationNext.setTextColor(ASDKColors.Text.primary.color)
        buttonCustomizationNext.setTextFontSize(Int(regularFont.pointSize))
        buttonCustomizationNext.setTextFontName(regularFont.fontName)
        customization.setButtonCustomization(buttonCustomization: buttonCustomizationNext, buttonType: .NEXT)
    }

    /// Cancel button
    private func addCancelButtonCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let buttonCustomizationCancel = ThreeDSWrapper.ButtonCustomization()
        buttonCustomizationCancel.setBackgroundColor(ASDKColors.Background.base.color)
        buttonCustomizationCancel.setTextColor(ASDKColors.Text.primary.color)
        buttonCustomizationCancel.setCustBorderWidth(0)
        buttonCustomizationCancel.setCustHighlitedColor(ASDKColors.Background.base.color)
        buttonCustomizationCancel.setTextColor(UIColor.Text.action)
        buttonCustomizationCancel.setTextFontSize(Int(regularFont.pointSize))
        buttonCustomizationCancel.setTextFontName(.systemFontName)
        buttonCustomizationCancel.setTextFontWeight(regularFontWeight)
        customization.setButtonCustomization(buttonCustomization: buttonCustomizationCancel, buttonType: .CANCEL)
    }

    /// TextBox
    private func addTextBoxCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let textBoxCustomization = ThreeDSWrapper.TextBoxCustomization()
        textBoxCustomization.setBorderWidth(1)
        textBoxCustomization.setBorderColor(ASDKColors.Background.separator.color)
        textBoxCustomization.setCornerRadius(.buttonCornerRadius)
        textBoxCustomization.setTextColor(ASDKColors.Text.primary.color)
        textBoxCustomization.setTextFontSize(Int(regularFont.pointSize))
        textBoxCustomization.setTextFontName(regularFont.fontName)
        customization.setTextBoxCustomization(textBoxCustomization)
    }

    /// Toolbar
    private func addToolbarCustomization(in customization: ThreeDSWrapper.UiCustomization) {
        let toolbarCustomization = ThreeDSWrapper.ToolbarCustomization()
        toolbarCustomization.setBackgroundColor(ASDKColors.Background.base.color)
        toolbarCustomization.setTextColor(ASDKColors.Text.primary.color)
        toolbarCustomization.setTextFontSize(Int(semiboldFont.pointSize))
        toolbarCustomization.setTextFontName(.systemFontName)
        toolbarCustomization.setTextFontWeight(semiboldFontWeight)
        toolbarCustomization.setHeaderText(Loc.TinkoffAcquiring.Threeds.acceptAuth)
        toolbarCustomization.setButtonText(Loc.TinkoffAcquiring.Threeds.cancelAuth)
        toolbarCustomization.isHideShadowImage = true
        customization.setToolbarCusomization(toolbarCustomization)
    }
}

// MARK: - Constants

private extension Int {
    static let buttonCornerRadius = 16
    static let headingTextFontSize = 30
}

private extension CGFloat {
    static let regularFontSize = 17 as CGFloat
}

private extension String {
    static let systemFontName = "System"
}

private extension UIColor {
    struct Text {
        static let action = UIColor(red: 0.2588, green: 0.5451, blue: 0.9765, alpha: 1)
    }
}
