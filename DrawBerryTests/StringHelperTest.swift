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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidPasswords() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertFalse(StringHelper.isInvalidPassword(password: "qwer1234"))

        XCTAssertFalse(StringHelper.isInvalidPassword(password: "Q1qwe131d"))
    }

    func testInvalidPasswords() {
        XCTAssertTrue(StringHelper.isInvalidPassword(password: ""))
        XCTAssertTrue(StringHelper.isInvalidPassword(password: "12345678"))
        XCTAssertTrue(StringHelper.isInvalidPassword(password: "q123456"))
        XCTAssertTrue(StringHelper.isInvalidPassword(password: "a123456!"))
    }

}
