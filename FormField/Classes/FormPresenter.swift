//
//  FormPresenter.swift
//  peiwoxue-ios
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


extension FormFieldDelegate {
    func formFieldWillValidate(_ formField: FormFieldProtocol) {

    }
}

open class FormPresenter: NSObject {
    var isValid = false
    open var validImageName: String?
    open var invalidImageName: String?
    open weak var formField: FormFieldProtocol!
    open weak var formDelegate: FormFieldDelegate?
    open var validation: Validation!

    open func checkValidity() {
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
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        formField.hideValidationImage()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
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

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if formField.returnKeyType == .next {
            formField.editNextForm()
            return true
        } else if formField.returnKeyType == .go {
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
