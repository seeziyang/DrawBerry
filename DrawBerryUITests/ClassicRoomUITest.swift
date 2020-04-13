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
    static var adapter: RoomNetworkAdapter!
    static let testRoomCode = RoomCode(value: "testroom", type: .ClassicRoom)

    override static func setUp() {
        FirebaseApp.configure()
        adapter = RoomNetworkAdapter(roomCode: testRoomCode)
    }

    override func setUp() {
        super.setUp()
    }

    func testClassicRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)

        verifyAppCurrentScreen(app: app)
    }
}
