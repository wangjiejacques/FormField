//
//  FormField.swift
//  peiwoxue-ios
//
//  Created by WANG Jie on 08/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public protocol FormFieldDelegate: class {
    func validateStateDidChange(isValid: Bool, errorMessage: String?)

    func isAllFormFieldsValid() -> Bool

    func formDidFinish()

    func formFieldWillValidate(formField: FormFieldProtocol)
}

public class FormField: UITextField {
    var presenter: FormPresenter!
    var validationImageView: UIImageView!
    /// one pixel height line in the bottom of the form field.
    public var bottomLine: UIView!
    /// if the form field's return type is `next`, when you clik `next`, the nextForm will become firstResponder.
    public weak var nextField: FormField?

    private var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: CGFloat(leftPadding.floatValue), bottom: 0, right: 0)
    }
    private var leftImageView: UIImageView!

    /// CGFloat not work here.
    @IBInspectable public var leftPadding: NSString! = "4"
    @IBInspectable public var leftImage: String! {
        didSet {
            leftImageView = UIImageView()
            leftImageView.contentMode = .Center
            leftImageView.image = UIImage(named: leftImage)
            leftViewMode = .Always
            leftView = leftImageView
        }
    }
    @IBInspectable public var validImage: String! {
        didSet {
            presenter.validImageName = validImage
        }
    }
    @IBInspectable public var invalidImage: String! {
        didSet {
            presenter.invalidImageName = invalidImage
        }
    }

    public weak var formDelegate: FormFieldDelegate? {
        set {
            presenter.formDelegate = newValue
        }
        get {
            return presenter.formDelegate
        }
    }
    public var validation: Validation {
        get {
            return presenter.validation
        }
        set {
            presenter.validation = newValue
        }
    }
    public var isValid: Bool {
        return presenter.isValid
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        presenter = FormPresenter()
        presenter.formField = self
        presenter.validation = DefaultValidation(minLength: 0, invalidMessage: nil)
        delegate = presenter

        initValidationImage()
        initBottomLine()

        clearButtonMode = .WhileEditing
        enablesReturnKeyAutomatically = true
        validationImageView.contentMode = .ScaleAspectFit

    }

    private func initValidationImage() {
        validationImageView = UIImageView()
        validationImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(validationImageView)
        validationImageView.hidden = true
        let views = ["validationImageView": validationImageView]
        let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:[validationImageView(20)]-4-|", options: [], metrics: nil, views: views)
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[validationImageView]-|", options: [], metrics: nil, views: views)
        addConstraints(constraintsH)
        addConstraints(constraintsV)
    }

    private func initBottomLine() {
        bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        bottomLine.hidden = true
        let views = ["bottomLine": bottomLine]
        let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[bottomLine]-|", options: [], metrics: nil, views: views)
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[bottomLine(1)]-|", options: [], metrics: nil, views: views)
        addConstraints(constraintsH)
        addConstraints(constraintsV)
    }

    public override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    public override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        let size: CGSize = CGSize(width: padding.left, height: frame.height)
        return CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    }

    func checkValidity() {
        presenter.checkValidity()
    }
}

extension FormField: FormFieldProtocol {
    public func hideValidationImage() {
        validationImageView.hidden = true
    }

    public func show(validationImage name: String) {
        validationImageView.hidden = false
        validationImageView.image = UIImage(named: name)
    }

    public func editNextForm() {
        nextField?.becomeFirstResponder()
    }

    public func stopEditing() {
        resignFirstResponder()
    }
}
