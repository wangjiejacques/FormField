//
//  FormPresenter.swift
//  Pods
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


public extension FormFieldDelegate {
    func formFieldWillValidate(_ formField: FormFieldProtocol) {

    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

open class FormPresenter: NSObject {
    var isValid = false
    open var validImageName: String?
    open var invalidImageName: String?
    open weak var formField: FormFieldProtocol!
    open weak var formDelegate: FormFieldDelegate?
    open var validation: Validation!

    public init(formField: FormFieldProtocol) {
        self.formField = formField
        NotificationCenter.default.addObserver(formField, selector: #selector(checkValidity), name: NSNotification.Name.UITextFieldTextDidChange, object: formField)
    }

    open func checkValidity() {
        isValid = true
        formDelegate?.formFieldWillValidate(self.formField)
        validation.validate(formField.text!, successHandler: {
            self.isValid = true
            self.formDelegate?.allFormFieldsValidate(didChangeTo: self.formDelegate?.isAllFormFieldsValid() ?? false)
            self.formDelegate?.formFieldValidate(didChangeTo: true, invalidMessage: nil)
        }) { (message) in
            self.isValid = false
            self.formDelegate?.formFieldValidate(didChangeTo: false, invalidMessage: nil)
            self.formDelegate?.allFormFieldsValidate(didChangeTo: false)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
            self.formDelegate?.formFieldValidate(didChangeTo: true, invalidMessage: nil)
            self.formField.show(validationImage: self.validImageName ?? "")
            self.formDelegate?.allFormFieldsValidate(didChangeTo: self.formDelegate?.isAllFormFieldsValid() ?? false)
        }) { (message) in
            guard !self.formField.editing else { return }
            self.isValid = false
            self.formField.show(validationImage: self.invalidImageName ?? "")
            self.formDelegate?.formFieldValidate(didChangeTo: false, invalidMessage: message)
            self.formDelegate?.allFormFieldsValidate(didChangeTo: false)
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

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let fd = formDelegate else { return true }
        return fd.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
