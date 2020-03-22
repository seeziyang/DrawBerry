//
//  SignUpViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class SignUpViewUITest: DrawBerryUITest {
    override func setUp() {
        super.setUp()
    }

    func testSignUpViewUILayout() {
        let app = initialiseAppToSignUpScreen()

        verifyAppCurrentScreen(app: app)
    }
}

extension SignUpViewUITest {
    private func initialiseAppToSignUpScreen() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isMenuPage(app: app) {
            attemptLogout(app: app)
        }
        app.buttons["Sign up"].tap()
        sleep(2)
        return app
    }

    private func isMenuPage(app: XCUIApplication) -> Bool {
        return app.buttons["Classic"].exists
    }

    private func attemptLogout(app: XCUIApplication) {
        app.buttons["Log out"].tap()
    }
}
