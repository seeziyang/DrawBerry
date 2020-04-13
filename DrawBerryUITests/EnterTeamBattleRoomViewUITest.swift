//
//  EnterTeamBattleRoomViewUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class EnterTeamBattleRoomViewUITest: EnterRoomUITest {
    override func setUp() {
        super.setUp()
    }

    func testEnterTeamBattleRoomViewUILayout() {
        let app = initialiseAppToEnterRoomScreen(type: .TeamBattleRoom)

        verifyAppCurrentScreen(app: app)
    }
}
