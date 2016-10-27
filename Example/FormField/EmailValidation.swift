//
//  EmailValidation.swift
//  Pods
//
//  Created by WANG Jie on 27/10/2016.
//
//

import Foundation
import FormField

class EmailValidation: Validation {
    private let invalidMessage: String?

    init(invalidMessage: String?) {
        self.invalidMessage = invalidMessage
    }
    
    func validate(text: String, successHandler: () -> Void, failureHandler: (message: String?) -> Void) {
        guard text.isEmail else {
            failureHandler(message: invalidMessage)
            return
        }
        successHandler()
    }
}
