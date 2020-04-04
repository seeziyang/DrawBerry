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
    let testRoomCode = RoomCode(value: "testroom", type: .CooperativeRoom)
    override static func setUp() {
        FirebaseApp.configure()
        adapter = RoomNetworkAdapter()
    }

    override func setUp() {
        super.setUp()
        CooperativeGameUITest.adapter.deleteRoom(roomCode: testRoomCode)
    }

    override func tearDown() {
        super.tearDown()
        CooperativeGameUITest.adapter.deleteRoom(roomCode: testRoomCode)
    }

    func testCooperativeGameUILayout_threePlayers() {
        let app = initialiseAppMoveToWaitingRoom()
        addSecondPlayer()
        addThirdPlayer()
        startGame(app: app)
        verifyAppCurrentScreen(app: app)
    }

    func testCooperativeGameUILayout_twoPlayers() {
        let app = initialiseAppMoveToWaitingRoom()
        addSecondPlayer()
        startGame(app: app)
        verifyAppCurrentScreen(app: app)
    }

    func testCooperativeGameUILayout_onePlayer() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        verifyAppCurrentScreen(app: app)
    }

    func testDraw() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)

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
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)

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
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 0).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectBlueInk() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectRedInk() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        // Select thick stroke to vary stroke from previous tests
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraser() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThinStroke() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 3).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectMediumStroke() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThickStroke() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testDrawBlueInk() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()

        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testTapEraserThenThickStroke() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 5).tap() // Should default select black ink

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraserThenBlueInk() {
        let app = initialiseAppMoveToWaitingRoom()
        startGame(app: app)
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 1).tap() // Should default select thin stroke

        verifyAppCurrentScreen(app: app)
    }

    func testTwoPlayer_completeFirstDrawing() {
        let app = initialiseAppMoveToWaitingRoom()
        addSecondPlayer()
        startGame(app: app)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap() // selecting thick stroke
        let canvas = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvas.swipeDown()
        app.buttons["Done"].tap()
        sleep(5)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testTwoPlayer_drawOutsideBounds() {
        let app = initialiseAppMoveToWaitingRoom()
        addSecondPlayer()
        startGame(app: app)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap() // selecting thick stroke
        let canvas = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvas.swipeUp()
        verifyAppCurrentScreen(app: app)
    }
}

extension CooperativeGameUITest {
    private func initialiseAppMoveToWaitingRoom() -> XCUIApplication {
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
        sleep(3)
        return app
    }

    private func addSecondPlayer() {
        RoomNetworkAdapterStub()
            .joinRoom(roomCode: testRoomCode, userID: "xYbVyQTsJbXOnTXDh2Aw8b1VMYG2", username: "admin2")
        sleep(3)
    }

    private func addThirdPlayer() {
        RoomNetworkAdapterStub()
            .joinRoom(roomCode: testRoomCode, userID: "KPXfiOZ5XxY4QHvGvYqSvaemTFj2", username: "admin3")
        sleep(3)
    }

    private func startGame(app: XCUIApplication) {
        app.navigationBars["Players"].buttons["Start"].tap()
        sleep(5)
    }

    private func attemptLogin(app: XCUIElement) {
        attemptLogin(app: app, email: "admin1@drawberry.com", password: "password1")
    }

    private func attemptLogin(app: XCUIElement, email: String, password: String) {
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["password"]

        emailTextField.tap()
        emailTextField.clearText()
        passwordSecureTextField.tap()
        emailTextField.tap()
        emailTextField.clearText()
        app.textFields["Email"].typeText(email)

        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()
        passwordSecureTextField.typeText(password)

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

class RoomNetworkAdapterStub: RoomNetworkAdapter {
    func joinRoom(roomCode: RoomCode, userID: String, username: String) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .setValue(["username": username,
                       "isRoomMaster": false])
    }
}
