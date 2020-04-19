//
//  CanvasTest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FBSnapshotTestCase
@testable import DrawBerry

class ClassicGameUITest: EnterRoomUITest {
    static var roomNetwork: RoomNetwork!
    static let testRoomCode = RoomCode(value: "testroom", type: .ClassicRoom)
    override static func setUp() {
        FirebaseApp.configure()
        roomNetwork = FirebaseRoomNetworkAdapter(roomCode: testRoomCode)
    }

    override func setUp() {
        super.setUp()
//        self.recordMode = true
        ClassicGameUITest.roomNetwork.deleteRoom()
    }

    override func tearDown() {
        super.tearDown()
        ClassicGameUITest.roomNetwork.deleteRoom()
        ClassicGameUITest.removeTestRoomFromUserInDb()
    }

    private static func removeTestRoomFromUserInDb() {
        guard let roomNetwork = roomNetwork as? FirebaseRoomNetworkAdapter else {
            return
        }

        roomNetwork.db.child("users")
            .child(EnterRoomUITest.defaultTestUser.uid)
            .child("activeNonRapidGames")
            .child(testRoomCode.value)
            .removeValue()
    }

    override internal func startGame(app: XCUIApplication, roomCode: RoomCode) {
        app.navigationBars[roomCode.value].switches["rapidToggle"].tap()
        app.navigationBars[roomCode.value].buttons["Start"].tap()
        sleep(5)
    }

    func testClassicGameUILayout() {
        let app = initialiseAppMoveToClassicCanvas()

        verifyAppCurrentScreen(app: app)
    }

    func testDraw() {
        let app = initialiseAppMoveToClassicCanvas()

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
        let app = initialiseAppMoveToClassicCanvas()

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
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 0).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectBlueInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectRedInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select thick stroke to vary stroke from previous tests
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraser() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThinStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 3).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectMediumStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThickStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testDrawBlueInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()

        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testDrawRedInk_thickStroke_blueInk_mediumStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 5).tap()
        canvasScrollView.swipeRight()
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()
        canvasScrollView.swipeDown()

        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testTapEraserThenThickStroke() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 5).tap() // Should default select black ink

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraserThenBlueInk() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 1).tap() // Should default select thin stroke

        verifyAppCurrentScreen(app: app)
    }

    func testCompleteDrawing_onePlayer() {
        let app = initialiseAppMoveToClassicCanvas()
        let palette = getPalette(from: app)
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 5).tap()
        canvasScrollView.swipeRight()
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()
        canvasScrollView.swipeDown()

        app.buttons["Done"].tap()
        sleep(2)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testCompleteDrawing_twoPlayer() {
        let app = initialiseAppToEnterRoomScreen(type: ClassicGameUITest.testRoomCode.type)
        createRoom(app: app, roomCode: ClassicGameUITest.testRoomCode)
        addSecondPlayer()
        startGame(app: app, roomCode: ClassicGameUITest.testRoomCode)
        let palette = getPalette(from: app)
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 5).tap()
        canvasScrollView.swipeRight()
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()
        canvasScrollView.swipeDown()

        app.buttons["Done"].tap()
        sleep(2)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
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
    private func addSecondPlayer() {
        RoomNetworkAdapterStub(roomCode: ClassicGameUITest.testRoomCode)
            .joinRoom(userID: "xYbVyQTsJbXOnTXDh2Aw8b1VMYG2", username: "admin2")
        sleep(3)
    }

    private func initialiseAppMoveToClassicCanvas() -> XCUIApplication {
        let app = initialiseAppToEnterRoomScreen(type: ClassicGameUITest.testRoomCode.type)
        createRoom(app: app, roomCode: ClassicGameUITest.testRoomCode)
        startGame(app: app, roomCode: ClassicGameUITest.testRoomCode)

        let topicTextField = app.textFields["Topic for Round 1"]
        topicTextField.tap()
        topicTextField.typeText("Topic")
        app.buttons["Ok"].tap()

        return app
    }

    private func getPalette(from app: XCUIApplication) -> XCUIElement {
        app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
    }

}
