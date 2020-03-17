//
//  Helper.swift
//  DrawBerry
//
//  Created by Calvin Chen on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import Foundation

enum StringHelper {

    /// Trims whitespace and new lines of a string
    static func trim(string: String?) -> String? {
        guard let string = string else {
            return nil
        }

        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Checks if input is an invalid password.
    /// Password length should be at least 8 characters with at least 1 Alphabet and 1 Number.
    static func isInvalidPassword(password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
        return !passwordTest.evaluate(with: password)
    }

    /// Checks if input is an invalid email.
    /// Contains "@" and "." separated by at least 2 characters.
    static func isInvalidEmail(email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")

        return !emailTest.evaluate(with: email)
    }

}
