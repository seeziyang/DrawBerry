//
//  EnterRoomUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 22/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class EnterRoomViewUITest: DrawBerryUITest {
    override func setUp() {
        super.setUp()
    }

    func testEnterRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen()

        verifyAppCurrentScreen(app: app)
    }
}

extension EnterRoomViewUITest {
    private func initialiseAppToEnterRoomScreen() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isLoginPage(app: app) {
            attemptLogin(app: app)
        }
        app.buttons["Classic"].tap()
        return app
    }

    private func attemptLogin(app: XCUIElement) {
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.clearText()
        app.textFields["Email"].typeText("admin@drawberry.com")

        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()
        passwordSecureTextField.typeText("admin123")

        app.buttons["login"].tap()
    }

    private func isLoginPage(app: XCUIElement) -> Bool {
        return app.buttons["Login"].exists
    }
}
