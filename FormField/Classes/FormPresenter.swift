//
//  FormPresenter.swift
//  peiwoxue-ios
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public class FormPresenter: NSObject {
    var isValid = false
    public var validImageName: String?
    public var invalidImageName: String?
    public weak var formField: FormFieldProtocol!
    public weak var formDelegate: FormFieldDelegate?
    public var validation: Validation!

    public func checkValidity() {
        isValid = true
        validation.validate(formField.text!, successHandler: {
            self.isValid = true
            self.formDelegate?.didValidateStateChanged(true, errorMessage: nil)
        }) { (message) in
            self.isValid = false
            self.formDelegate?.didValidateStateChanged(false, errorMessage: nil)
        }
    }
}

extension FormPresenter: UITextFieldDelegate {
    public func textFieldDidBeginEditing(textField: UITextField) {
        formField.hideValidationImage()
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        validation.validate(formField.text!, successHandler: {
            self.isValid = true
            self.formDelegate?.didValidateStateChanged(true, errorMessage: nil)
            self.formField.show(validationImage: self.validImageName ?? "")
        }) { (message) in
            guard !self.formField.editing else { return }
            self.isValid = false
            self.formField.show(validationImage: self.invalidImageName ?? "")
            self.formDelegate?.didValidateStateChanged(false, errorMessage: message)
        }
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if formField.returnKeyType == .Next {
            formField.editNextForm()
            return true
        } else if formField.returnKeyType == .Go {
            formField.stopEditing()
            guard formDelegate?.isAllFormValid() ?? false else {
                return false
            }
            formDelegate?.formDidFinish()
            return true
        }
        return true
    }
}
