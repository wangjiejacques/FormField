//
//  FormFieldDelegateMock.swift
//  Pods
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 WANG Jie. All rights reserved.
//

import Foundation
import FormField

class FormFieldDelegateMock: FormFieldDelegate {


    var isValid: Bool?
    var invalidMessage: String?
    var formDidFinishWasCalled = false
    var allFormFieldsIsValid: Bool?
    var isAllFromValid = false

    func formFieldValidate(formField: FormFieldProtocol, didChangeTo isValid: Bool, invalidMessage: String?) {
        self.isValid = isValid
        self.invalidMessage = invalidMessage
    }

    func allFormFieldsValidate(didChangeTo isValid: Bool) {
        allFormFieldsIsValid = isValid
    }

    func isAllFormFieldsValid() -> Bool {
        return isAllFromValid
    }

    func formDidFinish() {
        self.formDidFinishWasCalled = true
    }

    func formFieldWillValidate(_ formField: FormFieldProtocol) {

    }
}
