//
//  EnterClassicRoomViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 22/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class EnterClassicRoomViewUITest: EnterRoomUITest {
    override func setUp() {
        super.setUp()
    }

    func testEnterClassicRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .ClassicRoom)

        verifyAppCurrentScreen(app: app)
    }
}
