//
//  LoginViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class LoginViewUITest: DrawBerryUITest {
    override func setUp() {
        super.setUp()
    }

    func testLoginViewUILayout() {
        let app = initialiseAppToLoginScreen()

        verifyAppCurrentScreen(app: app)
    }
}

extension LoginViewUITest {
    private func initialiseAppToLoginScreen() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isMenuPage(app: app) {
            attemptLogout(app: app)
        }
        app.textFields["Email"].tap()
        app.textFields["Email"].clearText()
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].clearText()
        return app
    }

    private func isMenuPage(app: XCUIApplication) -> Bool {
        return app.buttons["Classic"].exists
    }

    private func attemptLogout(app: XCUIApplication) {
        app.buttons["Log out"].tap()
    }
}
