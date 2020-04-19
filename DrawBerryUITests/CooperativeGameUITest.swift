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

class CooperativeGameUITest: EnterRoomUITest {
    static var roomNetwork: RoomNetwork!
    static let testRoomCode = RoomCode(value: "testroom", type: .CooperativeRoom)
    override static func setUp() {
        FirebaseApp.configure()
        roomNetwork = FirebaseRoomNetworkAdapter(roomCode: testRoomCode)
    }

    override func setUp() {
        super.setUp()
        CooperativeGameUITest.roomNetwork.deleteRoom()
//        self.recordMode = true
    }

    override func tearDown() {
        super.tearDown()
        CooperativeGameUITest.roomNetwork.deleteRoom()
    }

    func testCooperativeGameUILayout_threePlayers() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        addSecondPlayer()
        addThirdPlayer()
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        verifyAppCurrentScreen(app: app)
    }

    func testCooperativeGameUILayout_twoPlayers() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        addSecondPlayer()
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        verifyAppCurrentScreen(app: app)
    }

    func testCooperativeGameUILayout_onePlayer() {
        let app = initialiseAppMoveToCooperativeGame()
        verifyAppCurrentScreen(app: app)
    }

    func testDraw() {
        let app = initialiseAppMoveToCooperativeGame()

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
        let app = initialiseAppMoveToCooperativeGame()

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
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 0).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectBlueInk() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectRedInk() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        // Select thick stroke to vary stroke from previous tests
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraser() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThinStroke() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 1).tap()
        palette.children(matching: .image).element(boundBy: 3).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectMediumStroke() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        // Select blue ink to vary color from previous tests
        palette.children(matching: .image).element(boundBy: 2).tap()
        palette.children(matching: .image).element(boundBy: 4).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testSelectThickStroke() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap()

        verifyAppCurrentScreen(app: app)
    }

    func testDrawBlueInk() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 1).tap()
        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeRight()

        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testTapEraserThenThickStroke() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 5).tap() // Should default select black ink

        verifyAppCurrentScreen(app: app)
    }

    func testTapEraserThenBlueInk() {
        let app = initialiseAppMoveToCooperativeGame()
        let palette = getPalette(from: app)
        // Select random color and stroke first
        palette.children(matching: .image).element(boundBy: 5).tap()
        palette.children(matching: .image).element(boundBy: 2).tap()

        palette.children(matching: .image).element(boundBy: 6).tap() // Eraser button, all icons should fade
        palette.children(matching: .image).element(boundBy: 1).tap() // Should default select thin stroke

        verifyAppCurrentScreen(app: app)
    }

    func testTwoPlayer_completeFirstDrawing() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        addSecondPlayer()
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap() // selecting thick stroke
        let canvas = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvas.swipeDown()
        app.buttons["Done"].tap()
        sleep(5)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testTwoPlayer_drawOutsideBounds() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        addSecondPlayer()
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap() // selecting thick stroke
        let canvas = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvas.swipeUp()
        verifyAppCurrentScreen(app: app)
    }
}

extension CooperativeGameUITest {
    private func initialiseAppMoveToCooperativeGame() -> XCUIApplication {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        return app
    }

    private func addSecondPlayer() {
        RoomNetworkAdapterStub(roomCode: CooperativeGameUITest.testRoomCode)
            .joinRoom(userID: "xYbVyQTsJbXOnTXDh2Aw8b1VMYG2", username: "admin2")
        sleep(3)
    }

    private func addThirdPlayer() {
        RoomNetworkAdapterStub(roomCode: CooperativeGameUITest.testRoomCode)
            .joinRoom(userID: "KPXfiOZ5XxY4QHvGvYqSvaemTFj2", username: "admin3")
        sleep(3)
    }

    private func getPalette(from app: XCUIApplication) -> XCUIElement {
        app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
    }

}

class RoomNetworkAdapterStub: FirebaseRoomNetworkAdapter {
    func joinRoom(userID: String, username: String) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .setValue(["username": username,
                       "isRoomMaster": false])
    }
}
