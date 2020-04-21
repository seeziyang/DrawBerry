//
//  TeamBattleUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 19/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FBSnapshotTestCase
@testable import DrawBerry

class TeamBattleUITest: EnterRoomUITest {
    static var roomNetwork: RoomNetwork!
    static let testRoomCode = RoomCode(value: "testroom", type: .TeamBattleRoom)
    override static func setUp() {
        FirebaseApp.configure()
        roomNetwork = FirebaseRoomNetworkAdapter(roomCode: testRoomCode)
    }

    override func setUp() {
        super.setUp()
        TeamBattleUITest.roomNetwork.deleteRoom()
    }

    override func tearDown() {
        super.tearDown()
        //TeamBattleUITest.roomNetwork.deleteRoom()
    }

    func testDrawer() {
        let app = initialiseAppToTeamBattleDrawer()

        verifyAppCurrentScreen(app: app)
    }

    func testGuesser() {
        let app = initialiseAppToTeamBattleGuesser()

        verifyAppCurrentScreen(app: app)
    }
}

extension TeamBattleUITest {
    private func initialiseAppToTeamBattleDrawer() -> XCUIApplication {
        let app = initialiseAppToEnterRoomScreen(type: .TeamBattleRoom)
        createRoom(app: app, roomCode: TeamBattleUITest.testRoomCode)
        add(player: UITestConstants.admin2_user, to: TeamBattleUITest.testRoomCode)
        startGame(app: app, roomCode: TeamBattleUITest.testRoomCode)
        return app
    }

    private func initialiseAppToTeamBattleGuesser() -> XCUIApplication {
        let app = initialiseAppToEnterRoomScreen(type: .TeamBattleRoom, as: UITestConstants.admin2_user)
        createRoom(app: app, roomCode: TeamBattleUITest.testRoomCode)
        add(player: UITestConstants.admin1_user, to: TeamBattleUITest.testRoomCode)
        startGame(app: app, roomCode: TeamBattleUITest.testRoomCode)
        sleep(2)
        return app
    }

    private func startGameProgramatically() {
        TeamBattleUITest.roomNetwork.stopObservingGameStart()
        TeamBattleUITest.roomNetwork.startGame(isRapid: true)
    }

    private func createRoomProgramatically(roomMaster: User, roomCode: RoomCode) {
        let db = Database.database().reference()
        let userID = roomMaster.uid
        let username = roomMaster.name

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .setValue([
                "isRapid": true,
                "players": [
                    userID: [
                        "username": username,
                        "isRoomMaster": true
                    ]
                ]
            ])
    }

}
