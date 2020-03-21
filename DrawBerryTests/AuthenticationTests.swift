//
//  AuthenticationTests.swift
//  DrawBerryTests
//
//  Created by Calvin Chen on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class AuthenticationTests: XCTestCase {
    let validEmail = "admin@drawberry.com"
    let invalidEmail = "admin@com"
    let validPassword = "admin123"
    let invalidPassword = "a123"

    func testLoginSuccess() {
        let expectation = self.expectation(description: "Login")
        let stub = AuthenticationUpdateDelegateStub(expectation: expectation)
        Authentication.delegate = stub
        Authentication.login(email: validEmail, password: validPassword)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(stub.result!)
    }

    func testLoginFailure_invalidPassword() {
        let expectation = self.expectation(description: "Login")
        let stub = AuthenticationUpdateDelegateStub(expectation: expectation)
        Authentication.delegate = stub
        Authentication.login(email: validEmail, password: invalidPassword)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(stub.result!)
    }

    func testLogoutSuccess() {
        let expectation = self.expectation(description: "Logout")
        let stub = AuthenticationUpdateDelegateStub(expectation: expectation)
        Authentication.delegate = stub
        Authentication.signOut()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(stub.result!)
    }

    func testSignupFailure_existingAccount() {
        let expectation = self.expectation(description: "Signup")
        let stub = AuthenticationUpdateDelegateStub(expectation: expectation)
        Authentication.delegate = stub
        Authentication.signUp(email: validEmail, password: validPassword)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(stub.result!)
    }

    func testSignupFailure_invalidEmail() {
        let expectation = self.expectation(description: "Signup")
        let stub = AuthenticationUpdateDelegateStub(expectation: expectation)
        Authentication.delegate = stub
        Authentication.signUp(email: invalidEmail, password: validPassword)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(stub.result!)
    }

    func testSignupFailure_invalidPassword() {
        let expectation = self.expectation(description: "Signup")
        let stub = AuthenticationUpdateDelegateStub(expectation: expectation)
        Authentication.delegate = stub
        Authentication.signUp(email: validEmail, password: invalidPassword)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(stub.result!)
    }

}

class AuthenticationUpdateDelegateStub: AuthenticationUpdateDelegate {
    var result: Bool?
    var expectation: XCTestExpectation

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func handleAuthenticationUpdate(status: Bool) {
        result = status
        expectation.fulfill()
    }
}
