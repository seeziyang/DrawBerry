//
//  ClassicRoomUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
import Firebase
@testable import DrawBerry

class ClassicRoomUITest: EnterRoomUITest {
    static var roomNetwork: RoomNetwork!
    static let testRoomCode = RoomCode(value: "testroom", type: .ClassicRoom)

    override static func setUp() {
        FirebaseApp.configure()
        roomNetwork = FirebaseRoomNetworkAdapter(roomCode: testRoomCode)
    }

    override func setUp() {
        super.setUp()
    }

    func testClassicRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)

        verifyAppCurrentScreen(app: app)
    }
}
