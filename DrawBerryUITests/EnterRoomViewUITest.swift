//
//  EnterRoomUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 22/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class EnterClassicRoomViewUITest: DrawBerryUITest {
    override func setUp() {
        super.setUp()
    }

    func testEnterClassicRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen()

        verifyAppCurrentScreen(app: app)
    }
}

extension EnterClassicRoomViewUITest {
    private func initialiseAppToEnterRoomScreen() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isLoginPage(app: app) {
            attemptLogin(app: app)
        }
        app.buttons["Classic"].tap()
        sleep(1)
        return app
    }

    private func attemptLogin(app: XCUIElement) {
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["password"]

        emailTextField.tap()
        emailTextField.clearText()
        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()
        emailTextField.tap()
        emailTextField.clearText()
        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()

        emailTextField.tap()
        emailTextField.typeText("admin1@drawberry.com")

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password1")

        app.buttons["login"].tap()
    }

    private func isLoginPage(app: XCUIElement) -> Bool {
        app.buttons["Login"].exists
    }
}
