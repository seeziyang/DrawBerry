//
//  Helper.swift
//  DrawBerry
//
//  Created by Calvin Chen on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

enum Helper {

    /// Trims whitespace and new lines
    static func trim(string: String?) -> String? {
        guard let string = string else {
            return nil
        }

        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
