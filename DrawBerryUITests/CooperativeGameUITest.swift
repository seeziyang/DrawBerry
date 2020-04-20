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
    static var roomNetwork1: RoomNetwork!
    static var roomNetwork2: RoomNetwork!
    static var roomNetwork3: RoomNetwork!
    static let testRoomCode = RoomCode(value: "testroom", type: .CooperativeRoom)
    static let testRoomCode2 = RoomCode(value: "testroom2", type: .CooperativeRoom)
    static let testRoomCode3 = RoomCode(value: "testroom3", type: .CooperativeRoom)
    override static func setUp() {
        FirebaseApp.configure()
        roomNetwork1 = FirebaseRoomNetworkAdapter(roomCode: testRoomCode)
        roomNetwork2 = FirebaseRoomNetworkAdapter(roomCode: testRoomCode2)
        roomNetwork3 = FirebaseRoomNetworkAdapter(roomCode: testRoomCode3)
    }

    override func setUp() {
        super.setUp()
        CooperativeGameUITest.roomNetwork1.deleteRoom()
        CooperativeGameUITest.roomNetwork2.deleteRoom()
        CooperativeGameUITest.roomNetwork3.deleteRoom()
    }

    override func tearDown() {
        super.tearDown()
        CooperativeGameUITest.roomNetwork1.deleteRoom()
        CooperativeGameUITest.roomNetwork2.deleteRoom()
        CooperativeGameUITest.roomNetwork3.deleteRoom()
    }

    func testCooperativeGameUILayout_threePlayers() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        add(player: UITestConstants.admin2_user, to: CooperativeGameUITest.testRoomCode)
        add(player: UITestConstants.admin3_user, to: CooperativeGameUITest.testRoomCode)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        verifyAppCurrentScreen(app: app)
    }

    func testCooperativeGameUILayout_twoPlayers() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        add(player: UITestConstants.admin2_user, to: CooperativeGameUITest.testRoomCode)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        verifyAppCurrentScreen(app: app)
    }

    func testDraw() {
        let app = initialiseAppMoveToCooperativeGame()

        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeDown()
        sleep(2)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)

        let palette = getPalette(from: app)
        palette.buttons["delete"].tap()
        canvasScrollView.swipeDown()
        sleep(1)
        verifyAppCurrentScreen(app: app, tolerance: 0.001)
    }

    func testUndo() {
        let app = initialiseAppMoveToCooperativeGame()

        // verify empty canvas first
        verifyAppCurrentScreen(app: app)

        let canvasScrollView = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvasScrollView.swipeDown()
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
        canvasScrollView.swipeDown()

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
        add(player: UITestConstants.admin2_user, to: CooperativeGameUITest.testRoomCode)
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
        add(player: UITestConstants.admin2_user, to: CooperativeGameUITest.testRoomCode)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        let palette = getPalette(from: app)
        palette.children(matching: .image).element(boundBy: 5).tap() // selecting thick stroke
        let canvas = app.scrollViews.children(matching: .other).element(boundBy: 0)
        canvas.swipeUp()
        verifyAppCurrentScreen(app: app)
    }

    func testTwoPlayer_userIsSecondPlayer() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom, as: UITestConstants.admin2_user)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        add(player: UITestConstants.admin1_user, to: CooperativeGameUITest.testRoomCode)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testThreePlayers_userIsThirdPlayer() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom, as: UITestConstants.admin3_user)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        add(player: UITestConstants.admin1_user, to: CooperativeGameUITest.testRoomCode)
        add(player: UITestConstants.admin2_user, to: CooperativeGameUITest.testRoomCode)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testTwoPlayers_userIsSecondPlayer_firstPlayerCompleteDrawing_getReady() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom, as: UITestConstants.admin3_user)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode3)
        add(player: UITestConstants.admin1_user, to: CooperativeGameUITest.testRoomCode3)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode3)

        let networkStub = FirebaseGameNetworkStub(roomCode: CooperativeGameUITest.testRoomCode3)
        let testDrawing = UIImage(
            named: "test-drawing",
            in: Bundle(for: CooperativeGameUITest.self),
            compatibleWith: nil)
        networkStub.expectation = self.expectation(description: "upload")
        networkStub.uploadUserDrawing(image: testDrawing ?? UIImage(), forRound: 1)
        waitForExpectations(timeout: 5, handler: nil)
        sleep(2)

        verifyAppCurrentScreen(app: app)
    }

    func testTwoPlayers_userIsSecondPlayer_firstPlayerCompleteDrawing() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom, as: UITestConstants.admin2_user)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode2)
        add(player: UITestConstants.admin1_user, to: CooperativeGameUITest.testRoomCode2)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode2)

        let networkStub = FirebaseGameNetworkStub(roomCode: CooperativeGameUITest.testRoomCode2)
        let testDrawing = UIImage(
            named: "test-drawing",
            in: Bundle(for: CooperativeGameUITest.self),
            compatibleWith: nil)
        networkStub.expectation = self.expectation(description: "upload")
        networkStub.uploadUserDrawing(image: testDrawing ?? UIImage(), forRound: 1)
        waitForExpectations(timeout: 5, handler: nil)
        sleep(7)

        verifyAppCurrentScreen(app: app)
    }
}

extension CooperativeGameUITest {
    private func initialiseAppMoveToCooperativeGame() -> XCUIApplication {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: CooperativeGameUITest.testRoomCode)
        add(player: UITestConstants.admin2_user, to: CooperativeGameUITest.testRoomCode)
        startGame(app: app, roomCode: CooperativeGameUITest.testRoomCode)
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

class FirebaseGameNetworkStub: FirebaseGameNetworkAdapter {
    var expectation: XCTestExpectation?

    override func uploadUserDrawing(image: UIImage, forRound round: Int) {
        guard let imageData = image.pngData() else {
            return
        }

        let userID = UITestConstants.admin1_user.uid

        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .child("rounds")
            .child("round\(round)")
            .child("hasUploadedImage")

        let cloudPathRef = cloud.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .child("\(round).png")

        cloudPathRef.putData(imageData, metadata: nil, completion: { _, error in
            if let error = error {
                print("Error \(error) occured while uploading user drawing to CloudStorage")
                return
            }

            dbPathRef.setValue(true)
        })
        dbPathRef.setValue(true)
        expectation?.fulfill()
    }

}
