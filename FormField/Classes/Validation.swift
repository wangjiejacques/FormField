//
//  Validation.swift
//  peiwoxue-ios
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol Validation: class {
    func validate(_ text: String, successHandler: () -> Void, failureHandler: (_ message: String?) -> Void)
}

open class DefaultValidation: Validation {

    fileprivate var minLength: Int
    fileprivate var invalidMessage: String?

    public init(minLength: Int, invalidMessage: String?) {
        self.minLength = minLength
        self.invalidMessage = invalidMessage
    }

    open func validate(_ text: String, successHandler: () -> Void, failureHandler: (_ message: String?) -> Void) {
        guard text.characters.count >= minLength else {
            failureHandler(invalidMessage)
            return
        }
        successHandler()
    }
}
