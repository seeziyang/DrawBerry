//
//  CanvasTest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
import Firebase
@testable import DrawBerry

class ClassicGameUITest: SnapshotTestCase {
    static var adapter: RoomNetworkAdapter!
    override static func setUp() {
        FirebaseApp.configure()
        adapter = RoomNetworkAdapter()
    }

    override func setUp() {
        super.setUp()
        ClassicGameUITest.adapter.deleteRoom(roomCode: "testroom")
    }

    override func tearDown() {
        super.tearDown()
        ClassicGameUITest.adapter.deleteRoom(roomCode: "testroom")
    }

    func testDraw() {
        let app = initialiseAppMoveToClassicCanvas()

        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()
        sleep(2)

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView, identifier: nil, perPixelTolerance: 0.001, overallTolerance: 0.001)

        let palette = getPalette(from: app)
        palette.buttons["delete"].tap()
        canvasScrollView.swipeRight()
        sleep(1)
        guard let secondStrokeView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(secondStrokeView, identifier: nil, perPixelTolerance: 0.001, overallTolerance: 0.001)
    }

    func testUndo() {
        let app = initialiseAppMoveToClassicCanvas()

        // Take screenshot of empty canvas first
        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)

        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()
        sleep(2)
        let palette = getPalette(from: app)
        palette.buttons["delete"].tap()

        guard let undoView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(undoView)
    }

    func testSelectBlackInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 0).tap()

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testSelectBlueInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testSelectRedInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select thick stroke to vary stroke from previous tests
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testTapEraser() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testSelectThinStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 3).tap()

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testSelectMediumStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testSelectThickStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap()

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testDrawBlueInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView, identifier: nil, perPixelTolerance: 0.001, overallTolerance: 0.001)
    }

    func testTapEraserThenThickStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 5).tap() // Should default select black ink

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    func testTapEraserThenBlueInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 1).tap() // Should default select thin stroke

        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)

    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }
}

extension ClassicGameUITest {
    // Helper methods
    private func initialiseAppMoveToClassicCanvas() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isLoginPage(app: app) {
            attemptLogin(app: app)
        }
        app.buttons["Classic"].tap()
        let roomCodeTextField = app.textFields["Room Code"]
        roomCodeTextField.tap()
        roomCodeTextField.typeText("testroom")
        let createButton = app.buttons["Create"]
        createButton.tap()
        app.navigationBars["Players"].buttons["Start"].tap()
        sleep(3)
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

    private func getPalette(from app: XCUIApplication) -> XCUIElement {
        return app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
    }
}
