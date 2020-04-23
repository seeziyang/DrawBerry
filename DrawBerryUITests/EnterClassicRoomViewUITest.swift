//
//  EnterClassicRoomViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 22/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
import Firebase
@testable import DrawBerry

class EnterClassicRoomViewUITest: EnterRoomUITest {
    static let invalidRoomCode = RoomCode(value: "[]", type: .ClassicRoom)
    static let existingRoomCode = RoomCode(value: "existing", type: .ClassicRoom)

    override static func setUp() {
        FirebaseApp.configure()
    }

    override func setUp() {
        super.setUp()
        EnterClassicRoomViewUITest.removeTestRoomFromUserInDb()
    }

    override func tearDown() {
        super.tearDown()
        FirebaseRoomNetworkAdapter(roomCode: EnterClassicRoomViewUITest.existingRoomCode).deleteRoom()
    }

    func testEnterClassicRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)

        verifyAppCurrentScreen(app: app)
    }

    func testCreateClassicRoomView_invalidRoomCode() {
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)
        createRoom(app: app, roomCode: EnterClassicRoomViewUITest.invalidRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testJoinClassicRoomView_invalidRoomCode() {
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)
        joinRoom(app: app, roomCode: EnterClassicRoomViewUITest.invalidRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    func testJoinClassicRoom_roomCodeInUse() {
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)
        createRoomProgramatically(
            roomMaster: UITestConstants.admin2_user, roomCode: EnterClassicRoomViewUITest.existingRoomCode)
        createRoom(app: app, roomCode: EnterClassicRoomViewUITest.existingRoomCode)

        verifyAppCurrentScreen(app: app)
    }

    private static func removeTestRoomFromUserInDb() {
        let db = Database.database().reference()

        db.child("users")
            .child(EnterRoomUITest.defaultTestUser.uid)
            .child("activeNonRapidGames")
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let activeGames = snapshot.value as? [String: Any] else {
                    return
                }

                let games = activeGames.keys
                games.forEach {
                    FirebaseRoomNetworkAdapter(roomCode: RoomCode(value: $0, type: .ClassicRoom)).deleteRoom()
                }
            })

        db.child("users")
            .child(EnterRoomUITest.defaultTestUser.uid)
            .child("activeNonRapidGames")
            .removeValue()
    }

}
