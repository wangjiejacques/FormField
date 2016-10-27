//
//  FormFieldDelegateMock.swift
//  peiwoxue-ios
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 WANG Jie. All rights reserved.
//

import Foundation
import FormField

class FormFieldDelegateMock: FormFieldDelegate {
    var isValid: Bool?
    var errorMessage: String?
    var formDidFinishTimes = 0

    var isAllFromValid = false

    func didValidateStateChanged(isValid: Bool, errorMessage: String?) {
        self.isValid = isValid
        self.errorMessage = errorMessage
    }

    func isAllFormValid() -> Bool {
        return isAllFromValid
    }

    func formDidFinish() {
        self.formDidFinishTimes += 1
    }
}
