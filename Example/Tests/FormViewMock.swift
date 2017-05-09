//
//  FormFieldMock.swift
//  Pods
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 WANG Jie. All rights reserved.
//

import Foundation
import FormField

class FormFieldMock: FormFieldProtocol {
    var showEmptyWarning: Bool = false
    var stopEditingTimes = 0
    var validationImageHidden: Bool?
    var nextFormTimes = 0
    var text: String? = "test"
    var editing: Bool = false
    var validationImageName: String?

    var returnKeyType: UIReturnKeyType = .default

    func stopEditing() {
        self.stopEditingTimes += 1
    }

    func show(validationImage name: String) {
        validationImageHidden = false
        validationImageName = name
    }

    func hideValidationImage() {
        self.validationImageHidden = true
    }

    func editNextForm() {
        self.nextFormTimes += 1
    }
}
