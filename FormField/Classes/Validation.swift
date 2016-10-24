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

public class SimpleValidation: Validation {
    public func validate(text: String, successHandler: () -> Void, failureHandler: (message: String?) -> Void) {
        guard text.characters.count > 0 else {
            failureHandler(message: "输入不能为空")
            return
        }
        successHandler()
    }
}
