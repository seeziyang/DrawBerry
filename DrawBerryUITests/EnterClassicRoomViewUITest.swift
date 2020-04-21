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
    override func setUp() {
        super.setUp()
    }

    func testEnterClassicRoomViewUILayout() {
        EnterClassicRoomViewUITest.removeTestRoomFromUserInDb()
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)

        verifyAppCurrentScreen(app: app)
    }

    private static func removeTestRoomFromUserInDb() {
        FirebaseApp.configure()
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
