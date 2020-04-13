//
//  EnterCooperativeRoomViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class EnterCooperativeRoomViewUITest: EnterRoomUITest {
    override func setUp() {
        super.setUp()
    }

    func testEnterCooperativeRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .CooperativeRoom)

        verifyAppCurrentScreen(app: app)
    }
}
