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

    func testCompetitiveModeNameEntryUILayout() {
        let app = initialiseAppMoveToNameEntry()
        verifyAppCurrentScreen(app: app)
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

        // Pick red for bottom left player
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
        let app = initializeAppMoveToVotingScreen()
        verifyAppCurrentScreen(app: app, tolerance: 0.01)
    }

    func testCompetitiveVotingResultUILayout() {
        let app = initializeAppMoveToVotingResultScreen()
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testCompetitiveScoreboardUILayout() {
        let app = intializeAppMoveToScoreboardScreen()
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testCompetitiveModeRestartsAfterResultScreen() {
        let app = intializeAppMoveToScoreboardScreen()
        app.images.element(boundBy: 1).tap()
        app.images.element(boundBy: 2).tap()
        app.images.element(boundBy: 3).tap()
        app.images.element(boundBy: 4).tap()

        sleep(1)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }
}

extension CompetitiveGameUITest {
    private func intializeAppMoveToScoreboardScreen() -> XCUIApplication {
        let app = initializeAppMoveToVotingResultScreen()

        app.images.element(boundBy: 3).tap()
        app.images.element(boundBy: 8).tap()
        app.images.element(boundBy: 15).tap()
        app.images.element(boundBy: 20).tap()

        return app
    }
    private func initializeAppMoveToVotingResultScreen() -> XCUIApplication {
        let app = initializeAppMoveToVotingScreen()

        // Player 1 votes
        app.images.element(boundBy: 0).tap()
        app.images.element(boundBy: 2).tap()

        // Player 2 votes
        app.images.element(boundBy: 6).tap()
        app.images.element(boundBy: 7).tap()

        // Player 3 votes
        app.images.element(boundBy: 10).tap()
        app.images.element(boundBy: 12).tap()

        // Player 4 votes
        app.images.element(boundBy: 15).tap()
        app.images.element(boundBy: 17).tap()

        sleep(1)
        return app
    }

    private func initializeAppMoveToVotingScreen() -> XCUIApplication {
        let app = initialiseAppMoveToCompetitveCanvas()

        let allCanvases = app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element

        allCanvases.children(matching: .other).element(boundBy: 0).swipeRight()
        allCanvases.children(matching: .other).element(boundBy: 2).swipeRight()
        allCanvases.children(matching: .other).element(boundBy: 4).swipeRight()
        allCanvases.children(matching: .other).element(boundBy: 6).swipeRight()

        sleep(4)

        app.images.element(boundBy: 1).tap()
        app.images.element(boundBy: 2).tap()
        app.images.element(boundBy: 3).tap()
        app.images.element(boundBy: 4).tap()

        sleep(2)
        return app
    }

    private func initialiseAppMoveToCompetitveCanvas() -> XCUIApplication {
        let app = initialiseAppMoveToNameEntry()
        print(app.buttons)
        app.buttons["Start Game"].tap()
        sleep(1)
        return app
    }

    private func initialiseAppMoveToNameEntry() -> XCUIApplication {
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
        app.textFields["Email"].typeText("admin1@drawberry.com")

        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()
        passwordSecureTextField.typeText("password1")

        app.buttons["login"].tap()
    }

    private func isLoginPage(app: XCUIElement) -> Bool {
        app.buttons["Login"].exists
    }
}
