//
//  Validation.swift
//  peiwoxue-ios
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol Validation: class {
    func validate(text: String, successHandler: () -> Void, failureHandler: (message: String?) -> Void)
}

public class DefaultValidation: Validation {

    private var minLength: Int
    private var invalidMessage: String?

    public init(minLength: Int, invalidMessage: String?) {
        self.minLength = minLength
        self.invalidMessage = invalidMessage
    }

    public func validate(text: String, successHandler: () -> Void, failureHandler: (message: String?) -> Void) {
        guard text.characters.count >= minLength else {
            failureHandler(message: invalidMessage)
            return
        }
        successHandler()
    }
}
