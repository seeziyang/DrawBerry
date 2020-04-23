//
//  EnterTeamBattleRoomViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import Firebase
import FBSnapshotTestCase

@testable import DrawBerry

class EnterTeamBattleRoomViewUITest: EnterRoomUITest {
    static let invalidRoomCode = RoomCode(value: "[]", type: .TeamBattleRoom)
    static let existingRoomCode = RoomCode(value: "existing", type: .TeamBattleRoom)

    override static func setUp() {
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        FirebaseRoomNetworkAdapter(roomCode: EnterTeamBattleRoomViewUITest.existingRoomCode).deleteRoom()
    }

    func testEnterTeamBattleRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .TeamBattleRoom)

        verifyAppCurrentScreen(app: app)
    }

    func testCreateTeamBattleRoomView_invalidRoomCode() {
        let app = initialiseAppToEnterRoomScreen(type: .TeamBattleRoom)
        createRoom(app: app, roomCode: EnterTeamBattleRoomViewUITest.invalidRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testJoinTeamBattleRoomView_invalidRoomCode() {
        let app = initialiseAppToEnterRoomScreen(type: .TeamBattleRoom)
        joinRoom(app: app, roomCode: EnterTeamBattleRoomViewUITest.invalidRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testCreateTeamBattleRoom_roomCodeInUse() {
        let app = initialiseAppToEnterRoomScreen(type: .TeamBattleRoom)
        createRoomProgramatically(
            roomMaster: UITestConstants.admin2_user, roomCode: EnterTeamBattleRoomViewUITest.existingRoomCode)
        createRoom(app: app, roomCode: EnterTeamBattleRoomViewUITest.existingRoomCode)

        verifyAppCurrentScreen(app: app)
    }

}
