//
//  EmailViewPresenter.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 27.01.2023.
//

import Foundation
import TinkoffASDKCore

final class EmailViewPresenter: IEmailViewOutput, IEmailViewPresenterInput {

    // MARK: Dependencies

    weak var view: IEmailViewInput? {
        didSet {
            setupView()
        }
    }

    private weak var output: IEmailViewPresenterOutput?
    private let emailValidator: IEmailValidator

    // MARK: IEmailViewPresenterInput Properties

    let customerEmail: String
    private(set) lazy var currentEmail: String = customerEmail
    var isEmailValid: Bool { emailValidator.isValid(currentEmail) }

    private var isFieldDidBeginEditing = false

    // MARK: Initialization

    init(
        customerEmail: String,
        output: IEmailViewPresenterOutput,
        emailValidator: IEmailValidator
    ) {
        self.customerEmail = customerEmail
        self.output = output
        self.emailValidator = emailValidator
    }
}

// MARK: - IEmailViewOutput

extension EmailViewPresenter {
    func textFieldDidBeginEditing() {
        isFieldDidBeginEditing = true
        view?.setTextFieldHeaderNormal()
        output?.emailTextFieldDidBeginEditing(self)
    }

    func textFieldDidChangeText(to text: String) {
        guard text != currentEmail else { return }

        currentEmail = text
        output?.emailTextField(self, didChangeEmail: currentEmail, isValid: isEmailValid)
    }

    func textFieldDidEndEditing() {
        viewSetTextFieldHeaderState()
        output?.emailTextFieldDidEndEditing(self)
    }

    func textFieldDidPressReturn() {
        view?.hideKeyboard()
        output?.emailTextFieldDidPressReturn(self)
    }
}

// MARK: - Private

extension EmailViewPresenter {
    private func setupView() {
        viewSetTextFieldHeaderState()
        view?.setTextField(text: currentEmail, animated: false)
    }

    private func viewSetTextFieldHeaderState() {
        guard isFieldDidBeginEditing || !currentEmail.isEmpty else {
            view?.setTextFieldHeaderNormal()
            return
        }

        isEmailValid ? view?.setTextFieldHeaderNormal() : view?.setTextFieldHeaderError()
    }
}
