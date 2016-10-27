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
    var errorMessage: String?
    var formDidFinishWasCalled = false

    var isAllFromValid = false

    func validateStateDidChange(_ isValid: Bool, errorMessage: String?) {
        self.isValid = isValid
        self.errorMessage = errorMessage
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
