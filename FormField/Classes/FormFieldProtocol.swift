//
//  FormFieldProtocol.swift
//  Pods
//
//  Created by WANG Jie on 12/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol FormFieldProtocol: class {

    func show(validationImage name: String)

    func hideValidationImage()

    var text: String? { get set }

    var editing: Bool { get }

    var returnKeyType: UIReturnKeyType { get set }

    var showEmptyWarning: Bool { get set }

    func editNextForm()

    func stopEditing()
}
