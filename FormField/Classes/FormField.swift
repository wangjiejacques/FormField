//
//  FormField.swift
//  Pods
//
//  Created by WANG Jie on 08/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


public protocol FormFieldDelegate: class {
    func formFieldValidate(didChangeTo isValid: Bool, invalidMessage: String?)

    func allFormFieldsValidate(didChangeTo isValid: Bool)

    func isAllFormFieldsValid() -> Bool

    func formDidFinish()

    func formFieldWillValidate(_ formField: FormFieldProtocol)

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

open class FormField: UITextField {
    var presenter: FormPresenter!
    var validationImageView: UIImageView!
    /// one pixel height line in the bottom of the form field.
    open var bottomLine: UIView!
    /// if the form field's return type is `next`, when you clik `next`, the nextForm will become firstResponder.
    open weak var nextField: UITextField?

    /// the rect for the left image, if the leftImageRect is nil, than the default rect is (0, 0, 30, view.height).
    open var leftImageRect: CGRect?

    fileprivate var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: CGFloat(leftPadding.floatValue), bottom: 0, right: 30)
    }
    var leftImageView: UIImageView!

    open override var delegate: UITextFieldDelegate? {
        didSet {
            guard delegate is FormPresenter else {
                fatalError("don't use delegate, use forfield delegate")
            }
        }
    }

    /// CGFloat not work here.
    @IBInspectable open var leftPadding: NSString! = "4"
    @IBInspectable open var leftImage: String! {
        didSet {
            leftImageView = UIImageView()
            leftImageView.contentMode = .scaleAspectFit
            leftImageView.image = UIImage(named: leftImage)
            leftViewMode = .always
            leftView = leftImageView
        }
    }
    @IBInspectable open var validImage: String! {
        didSet {
            presenter.validImageName = validImage
        }
    }
    @IBInspectable open var invalidImage: String! {
        didSet {
            presenter.invalidImageName = invalidImage
        }
    }

    open weak var formDelegate: FormFieldDelegate? {
        set {
            presenter.formDelegate = newValue
        }
        get {
            return presenter.formDelegate
        }
    }
    open var validation: Validation {
        get {
            return presenter.validation
        }
        set {
            presenter.validation = newValue
        }
    }
    open var isValid: Bool {
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

    fileprivate func commonInit() {
        presenter = FormPresenter(formField: self)
        presenter.validation = DefaultValidation(minLength: 0, invalidMessage: nil)
        delegate = presenter

        layoutMargins = UIEdgeInsets.zero
        initValidationImage()
        initBottomLine()

        clearButtonMode = .whileEditing
        enablesReturnKeyAutomatically = true
        validationImageView.contentMode = .scaleAspectFit

    }

    fileprivate func initValidationImage() {
        validationImageView = UIImageView()
        validationImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(validationImageView)
        validationImageView.isHidden = true
        let views: [String: UIView] = ["validationImageView": validationImageView]
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:[validationImageView(20)]-4-|", options: [], metrics: nil, views: views)
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[validationImageView]-|", options: [], metrics: nil, views: views)
        addConstraints(constraintsH)
        addConstraints(constraintsV)
    }

    fileprivate func initBottomLine() {
        bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        bottomLine.isHidden = true
        let views: [String: UIView] = ["bottomLine": bottomLine]
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[bottomLine]-|", options: [], metrics: nil, views: views)
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomLine(1)]-|", options: [], metrics: nil, views: views)
        addConstraints(constraintsH)
        addConstraints(constraintsV)
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        if let leftImageRect = leftImageRect {
            return leftImageRect
        }
        let size: CGSize = CGSize(width: 30, height: frame.height)
        return CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    }

    open func checkValidity() {
        presenter.checkValidity()
    }
}

extension FormField: FormFieldProtocol {
    public func hideValidationImage() {
        validationImageView.isHidden = true
    }

    public func show(validationImage name: String) {
        validationImageView.isHidden = false
        validationImageView.image = UIImage(named: name)
    }

    public func editNextForm() {
        nextField?.becomeFirstResponder()
    }

    public func stopEditing() {
        resignFirstResponder()
    }
}
