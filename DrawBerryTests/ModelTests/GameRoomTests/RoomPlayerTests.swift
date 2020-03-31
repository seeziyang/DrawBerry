//
//  RoomPlayerTests.swift
//  DrawBerryTests
//
//  Created by See Zi Yang on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class RoomPlayerTests: XCTestCase {
    func testConstruct() {
        let roomPlayer = RoomPlayer(name: "name", uid: "123abc", isRoomMaster: true)

        XCTAssertEqual(roomPlayer.name, "name", "RoomPlayer's name is not constructed properly")
        XCTAssertEqual(roomPlayer.uid, "123abc", "RoomPlayer's uid is not constructed properly")
        XCTAssertTrue(roomPlayer.isRoomMaster, "RoommPlayer's isRoomMaster is not constructed properly")
    }

    func testCompare() {
        let roomPlayer = RoomPlayer(name: "bob", uid: "q1w2e3", isRoomMaster: true)
        let largerRoomPlayer = RoomPlayer(name: "alice", uid: "r1w2e3")
        let smallerRoomPlayer = RoomPlayer(name: "charles", uid: "p1w2e3")
        let sameUIDDifferentDetails = RoomPlayer(name: "bobo", uid: "q1w2e3")
        XCTAssertTrue(roomPlayer < largerRoomPlayer)
        XCTAssertTrue(smallerRoomPlayer < roomPlayer)
        XCTAssertTrue(smallerRoomPlayer < largerRoomPlayer)
        XCTAssertEqual(roomPlayer, sameUIDDifferentDetails)
    }
}
