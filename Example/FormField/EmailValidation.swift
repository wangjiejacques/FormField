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
    fileprivate let invalidMessage: String?

    init(invalidMessage: String?) {
        self.invalidMessage = invalidMessage
    }
    
    func validate(_ text: String, successHandler: () -> Void, failureHandler: (_ message: String?) -> Void) {
        guard text.isEmail else {
            failureHandler(invalidMessage)
            return
        }
        successHandler()
    }
}
