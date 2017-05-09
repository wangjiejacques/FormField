//
//  FormSpec.swift
//  Pods
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 WANG Jie. All rights reserved.
//

import Foundation
import Quick
import Nimble
import FormField

class FormSpec: QuickSpec {

    override func spec() {
        var formPresenter: FormPresenter!
        var formField: FormFieldMock!
        var formFieldDelegate: FormFieldDelegateMock!
        var validation: ValidationMock!

        describe("Given a user input a form field") {
            beforeEach {
                formField = FormFieldMock()
                formPresenter = FormPresenter(formField: formField)

                formFieldDelegate = FormFieldDelegateMock()
                formPresenter.formDelegate = formFieldDelegate

                validation = ValidationMock()
                formPresenter.validation = validation
            }
            context("When check the validation of a form field") {
                context("When the form field is valid, all formFields is not valid") {
                    beforeEach {
                        validation.shouldValid = true
                        formFieldDelegate.isAllFromValid = false
                        formPresenter.checkValidity()
                    }
                    it("Then the validate state of the form delegate should be true") {
                        expect(formFieldDelegate.isValid).to(beTrue())
                        expect(formFieldDelegate.allFormFieldsIsValid).to(beFalse())
                    }
                }
                context("When the form field is not valid") {
                    beforeEach {
                        validation.shouldValid = false
                        formPresenter.checkValidity()
                    }
                    it("Then the validate state of the form delegate should be false") {
                        expect(formFieldDelegate.isValid).to(beFalse())
                        expect(formFieldDelegate.allFormFieldsIsValid).to(beFalse())
                    }
                }
            }

            context("When the form field text did change") {
                beforeEach {
                    formPresenter.textFieldDidBeginEditing(UITextField())
                }
                it("Then the form field should hidden the validation image") {
                    expect(formField.validationImageHidden).to(beTrue())
                }
            }

            context("When the user end editing, and the form is valid") {
                beforeEach {
                    validation.shouldValid = true
                    formPresenter.textFieldDidEndEditing(UITextField())
                }
                it("Then the validation state of the form field delegate should be true") {
                    expect(formFieldDelegate.isValid).to(beTrue())
                }
            }
            context("When the user end editing, and the form is not valid") {
                beforeEach {
                    validation.shouldValid = false
                    formPresenter.textFieldDidEndEditing(UITextField())
                }
                it("Then the validation state of the form field delegate should be false") {
                    expect(formFieldDelegate.isValid).to(beFalse())
                }
                it("Then the form field should show the validation image") {
                    expect(formField.validationImageHidden).to(beFalse())
                }
            }

            context("When the user click the return key and the form field is not the last one") {
                beforeEach {
                    formField.returnKeyType = .next
                    _ = formPresenter.textFieldShouldReturn(UITextField())
                }
                it("Then the next form field should begin editing") {
                    expect(formField.nextFormTimes).to(equal(1))
                }
            }
            context("When the user click the return key, the form field is the last one and the form should finish") {
                beforeEach {
                    formField.returnKeyType = .go
                    formFieldDelegate.isAllFromValid = true
                    _ = formPresenter.textFieldShouldReturn(UITextField())
                }

                it("Then the next form field should not begin editing") {
                    expect(formField.nextFormTimes).to(equal(0))
                    expect(formFieldDelegate.formDidFinishWasCalled).to(equal(true))
                }
            }
            context("When the user click the return key, the form is the last one and the form should not finish") {
                beforeEach {
                    formField.returnKeyType = .go
                    formFieldDelegate.isAllFromValid = false
                    _ = formPresenter.textFieldShouldReturn(UITextField())
                }

                it("Then the next form field should not begin editing") {
                    expect(formField.nextFormTimes).to(equal(0))
                    expect(formFieldDelegate.formDidFinishWasCalled).to(equal(false))
                }
            }

            context("When the field shows empty warning message and the text is empty.") {
                beforeEach {
                    validation.shouldValid = false
                    formField.text = ""
                    formPresenter.textFieldDidEndEditing(UITextField())
                }
                it("Then the field is not valid, but it not shows warning") {
                    expect(formFieldDelegate.formFieldValidateCalled).to(beFalse())
                }
            }
            context("When the field shows empty warning message and the text is empty") {
                beforeEach {
                    validation.shouldValid = false
                    formField.text = ""
                    formField.showEmptyWarning = true
                    formPresenter.textFieldDidEndEditing(UITextField())
                }
                it("Then the field is not valid, and it shows the warning") {
                    expect(formFieldDelegate.formFieldValidateCalled).to(beTrue())
                }
            }
        }
    }

}
