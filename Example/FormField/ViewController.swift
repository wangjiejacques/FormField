//
//  ViewController.swift
//  FormField
//
//  Created by WANG Jie on 10/24/2016.
//  Copyright (c) 2016 WANG Jie. All rights reserved.
//

import UIKit
import FormField

class ViewController: UITableViewController {

    @IBOutlet weak var firstnameField: FormField!
    @IBOutlet weak var emailField: FormField!
    @IBOutlet weak var passwordField: FormField!
    @IBOutlet weak var passwordRepeatField: FormField!
    var passwordRepeatValidation: PasswordRepeatValidation!

    var allFormFields: [FormField] {
        return [firstnameField, emailField, passwordField, passwordRepeatField]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        firstnameField.validation = DefaultValidation(minLength: 4, invalidMessage: "Firstname must be contain at least 4 chars")
        emailField.validation = EmailValidation(invalidMessage: "Email not valid")
        passwordField.validation = DefaultValidation(minLength: 8, invalidMessage: "Password must be containt at least 8 chars")
        passwordRepeatField.validation = PasswordRepeatValidation(invalidMessage: "Password not correct")
        for (index, field) in allFormFields.enumerated() {
            if index+1 < allFormFields.count {
                field.nextField = allFormFields[index+1]
            }
            field.formDelegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: FormFieldDelegate {


    func allFormFieldsValidate(didChangeTo isValid: Bool) {
        // TODO you can disable, enable your sign up button
    }

    func formFieldValidate(didChangeTo isValid: Bool, invalidMessage: String?) {
        // TODO show the invalid message
    }


    func isAllFormFieldsValid() -> Bool {
        return allFormFields.reduce(true, { $0 && $1.isValid })
    }

    func formDidFinish() {
        /// do signup or login
    }

    func formFieldWillValidate(_ formField: FormFieldProtocol) {
        if formField === passwordRepeatField {
            passwordRepeatValidation.password = passwordField.text
        }
    }

    
}
