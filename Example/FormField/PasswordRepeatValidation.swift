//
//  PasswordRepeatValidation.swift
//  FormField
//
//  Created by WANG Jie on 27/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import FormField

class PasswordRepeatValidation: Validation {

    var password: String?
    let invalidMessage: String

    init(invalidMessage: String) {
        self.invalidMessage = invalidMessage
    }
    
    func validate(_ text: String, successHandler: @escaping () -> Void, failureHandler: @escaping (_ message: String?) -> Void) {
        guard password == text else {
            failureHandler(invalidMessage)
            return
        }
        successHandler()
    }
}
