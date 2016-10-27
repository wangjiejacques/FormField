//
//  String+validation.swift
//  Pods
//
//  Created by WANG Jie on 27/10/2016.
//
//

import Foundation

public extension String {

    public var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)

        return emailPredicate.evaluate(with: self)
    }
}
