//
//  EnterCooperativeRoomViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import Firebase
import FBSnapshotTestCase

@testable import DrawBerry

class EnterCooperativeRoomViewUITest: EnterRoomUITest {
    static let invalidRoomCode = RoomCode(value: "[]", type: .CooperativeRoom)
    static let existingRoomCode = RoomCode(value: "existing", type: .CooperativeRoom)

    override static func setUp() {
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        FirebaseRoomNetworkAdapter(roomCode: EnterCooperativeRoomViewUITest.existingRoomCode).deleteRoom()
    }

    func testEnterCooperativeRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)

        verifyAppCurrentScreen(app: app)
    }

    func testCreateCooperativeRoomView_invalidRoomCode() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoom(app: app, roomCode: EnterCooperativeRoomViewUITest.invalidRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testJoinCooperativeRoomView_invalidRoomCode() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        joinRoom(app: app, roomCode: EnterCooperativeRoomViewUITest.invalidRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testCreateCooperativeRoom_roomCodeInUse() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)
        createRoomProgramatically(
            roomMaster: UITestConstants.admin2_user, roomCode: EnterCooperativeRoomViewUITest.existingRoomCode)
        createRoom(app: app, roomCode: EnterCooperativeRoomViewUITest.existingRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testJoinCooperativeRoom_roomDoesNotExist() {
        recordMode = true
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)
        joinRoom(app: app, roomCode: EnterCooperativeRoomViewUITest.existingRoomCode)

        verifyAppCurrentScreen(app: app)
    }

}
