//
//  StringHelperTest.swift
//  DrawBerryTests
//
//  Created by Calvin Chen on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class StringHelperTest: XCTestCase {

    func testValidEmails() {
        XCTAssertFalse(StringHelper.isInvalidEmail(email: "a@b.com"))
        XCTAssertFalse(StringHelper.isInvalidEmail(email: "a@u.edu"))
    }

    func testInvalidEmails() {

        // Missing characters before "@"
        XCTAssertTrue(StringHelper.isInvalidEmail(email: "@a.com"))

        // Missing characters between "@" and "a"
        XCTAssertTrue(StringHelper.isInvalidEmail(email: "a@.com"))

        // Missing characters after "."
        XCTAssertTrue(StringHelper.isInvalidEmail(email: "a@gmail."))

        // Missing "@" character
        XCTAssertTrue(StringHelper.isInvalidEmail(email: "a.com"))

        // Missing "." character
        XCTAssertTrue(StringHelper.isInvalidEmail(email: "a@gmail"))

        // Empty string is invalid
        XCTAssertTrue(StringHelper.isInvalidEmail(email: ""))

    }

    func testValidPasswords() {
        XCTAssertFalse(StringHelper.isInvalidPassword(password: "qwer1234"))

        XCTAssertFalse(StringHelper.isInvalidPassword(password: "Q1qwe131d"))
    }

    func testInvalidPasswords() {

        // Empty string is invalid
        XCTAssertTrue(StringHelper.isInvalidPassword(password: ""))

        // Whitespaces are not allowed
        XCTAssertTrue(StringHelper.isInvalidPassword(password: "abc123 456"))

        // Missing an alphabet
        XCTAssertTrue(StringHelper.isInvalidPassword(password: "12345678"))

        // Password length should be at least 8
        XCTAssertTrue(StringHelper.isInvalidPassword(password: "q123456"))

        // Special characters are not allowed
        XCTAssertTrue(StringHelper.isInvalidPassword(password: "a123456!"))
    }

}
