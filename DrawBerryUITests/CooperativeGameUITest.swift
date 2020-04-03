//
//  CooperativeGameUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 3/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FBSnapshotTestCase
@testable import DrawBerry

class CooperativeGameUITest: DrawBerryUITest {
    static var adapter: RoomNetworkAdapter!
    override static func setUp() {
        FirebaseApp.configure()
        adapter = RoomNetworkAdapter()
    }

    override func setUp() {
        super.setUp()
        CooperativeGameUITest.adapter.deleteRoom(roomCode: RoomCode(value: "testroom", type: .CooperativeRoom))
    }

    override func tearDown() {
        super.tearDown()
        CooperativeGameUITest.adapter.deleteRoom(roomCode: RoomCode(value: "testroom", type: .CooperativeRoom))
    }

    func testCooperativeGameUILayout() {
        let app = initialiseAppMoveToCooperativeCanvas()
        verifyAppCurrentScreen(app: app)
    }

    func testDraw() {
        let app = initialiseAppMoveToCooperativeCanvas()

        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()
        sleep(2)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)

        let palette = getPalette(from: app)
        palette.buttons["delete"].tap()
        canvasScrollView.swipeRight()
        sleep(1)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testUndo() {
        let app = initialiseAppMoveToCooperativeCanvas()

        // verify empty canvas first
        verifyAppCurrentScreen(app: app)

        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()
        sleep(2)
        let palette = getPalette(from: app)
        palette.buttons["delete"].tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectBlackInk() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 0).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectBlueInk() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectRedInk() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        // Select thick stroke to vary stroke from previous tests
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraser() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThinStroke() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 3).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectMediumStroke() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThickStroke() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testDrawBlueInk() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()

        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testTapEraserThenThickStroke() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 5).tap() // Should default select black ink

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraserThenBlueInk() {
        let app = initialiseAppMoveToCooperativeCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 1).tap() // Should default select thin stroke

        verifyAppCurrentScreen(app: app)
    }
}

extension CooperativeGameUITest {
    // Helper methods
    private func initialiseAppMoveToCooperativeCanvas() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isLoginPage(app: app) {
            attemptLogin(app: app)
        }
        app.buttons["Cooperative"].tap()
        let roomCodeTextField = app.textFields["Room Code"]
        roomCodeTextField.tap()
        roomCodeTextField.typeText("testroom")
        let createButton = app.buttons["Create"]
        createButton.tap()
        app.navigationBars["Players"].buttons["Start"].tap()
        sleep(5)
        return app
    }

    private func attemptLogin(app: XCUIElement) {
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["password"]

        emailTextField.tap()
        emailTextField.clearText()
        passwordSecureTextField.tap()
        emailTextField.tap()
        emailTextField.clearText()
        app.textFields["Email"].typeText("admin1@drawberry.com")

        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()
        passwordSecureTextField.typeText("password1")

        app.buttons["login"].tap()
    }

    private func isLoginPage(app: XCUIElement) -> Bool {
        app.buttons["Login"].exists
    }

    private func getPalette(from app: XCUIApplication) -> XCUIElement {
        app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
    }

}
