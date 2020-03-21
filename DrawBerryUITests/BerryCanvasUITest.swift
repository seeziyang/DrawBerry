//
//  CanvasTest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class BerryCanvasUITest: SnapshotTestCase {
    override func setUp() {
        super.setUp()
        //recordMode = true
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
    func setText(text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems["Paste"].tap()
    }
}

extension BerryCanvasUITest {
    // Helper methods
    private func initialiseAppMoveToClassicCanvas() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Classic"].tap()
        let roomCodeTextField = app.textFields["Room Code"]
        roomCodeTextField.tap()
        roomCodeTextField.typeText("testroom")
        app.buttons["Join"].tap()
        app.navigationBars["Players"].buttons["Start"].tap()
        sleep(3)
        return app
    }

    private func getPalette(from app: XCUIApplication) -> XCUIElement {
        return app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
    }
}
