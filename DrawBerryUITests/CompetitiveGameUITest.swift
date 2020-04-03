//
//  CompetitiveGameUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class CompetitiveGameUITest: DrawBerryUITest {
    override func setUp() {
        super.setUp()
    }

    func testCompetitiveModeUILayout() {
        let app = initialiseAppMoveToCompetitveCanvas()

        verifyAppCurrentScreen(app: app)
    }

    func testFirstBlackSecondRedThirdBlueFourthBlack() {
        let app = initialiseAppMoveToCompetitveCanvas()

        let allCanvases = app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element

        // Pick black for top left player
        allCanvases.children(matching: .other).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .image).element(boundBy: 5).tap()

        // Pick blue for top right player
        allCanvases.children(matching: .other).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .image).element(boundBy: 4).tap()

        // Pick red for bottom left playe
        allCanvases.children(matching: .other).element(boundBy: 4)
            .children(matching: .other).element
            .children(matching: .image).element(boundBy: 2).tap()

        // Pick black for bottom right player
        allCanvases.children(matching: .other).element(boundBy: 6)
            .children(matching: .other).element
            .children(matching: .image).element(boundBy: 0).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testCompetitiveVotingUILayout() {
        let app = initialiseAppMoveToCompetitveCanvas()

    }
}

extension CompetitiveGameUITest {
    private func initialiseAppMoveToCompetitveCanvas() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isLoginPage(app: app) {
            attemptLogin(app: app)
        }
        app.buttons["Competitive"].tap()
        sleep(1)
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
        app.buttons["Login"].exists
    }
}
