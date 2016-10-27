//
//  FormPresenter.swift
//  peiwoxue-ios
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol FormFieldDelegate: class {
    func validateStateDidChange(isValid: Bool, errorMessage: String?)

    func isAllFormFieldsValid() -> Bool

    func formDidFinish()

    func formFieldWillValidate(formField: FormFieldProtocol)
}

extension FormFieldDelegate {
    func formFieldWillValidate(formField: FormFieldProtocol) {

    }
}

public class FormPresenter: NSObject {
    var isValid = false
    public var validImageName: String?
    public var invalidImageName: String? = "icon_error"
    public weak var formField: FormFieldProtocol!
    public weak var formDelegate: FormFieldDelegate?
    public var validation: Validation!

    public func checkValidity() {
        isValid = true
        formDelegate?.formFieldWillValidate(self.formField)
        validation.validate(formField.text!, successHandler: {
            self.isValid = true
            self.formDelegate?.validateStateDidChange(true, errorMessage: nil)
        }) { (message) in
            self.isValid = false
            self.formDelegate?.validateStateDidChange(false, errorMessage: nil)
        }
    }
}

extension FormPresenter: UITextFieldDelegate {
    public func textFieldDidBeginEditing(textField: UITextField) {
        formField.hideValidationImage()
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        formDelegate?.formFieldWillValidate(formField)
        validation.validate(formField.text!, successHandler: {
            self.isValid = true
            self.formDelegate?.validateStateDidChange(true, errorMessage: nil)
            self.formField.show(validationImage: self.validImageName ?? "")
        }) { (message) in
            guard !self.formField.editing else { return }
            self.isValid = false
            self.formField.show(validationImage: self.invalidImageName ?? "")
            self.formDelegate?.validateStateDidChange(false, errorMessage: message)
        }
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if formField.returnKeyType == .Next {
            formField.editNextForm()
            return true
        } else if formField.returnKeyType == .Go {
            formField.stopEditing()
            guard formDelegate?.isAllFormFieldsValid() ?? false else {
                return false
            }
            formDelegate?.formDidFinish()
            return true
        }
        return true
    }
}
