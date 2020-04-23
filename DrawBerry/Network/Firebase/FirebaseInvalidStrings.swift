//
//  FirebaseInvalidStrings.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 20/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct FirebaseInvalidStrings {
    static let invalidCharacters = [".", "#", "$", "[", "]"]

    static func isInvalid(name: String) -> Bool {
        let containsInvalidChar = !name.map { String($0) }.allSatisfy { !invalidCharacters.contains($0) }
        return containsInvalidChar
    }
}
