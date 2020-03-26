//
//  RoomCodeTests.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class RoomCodeTests: XCTestCase {
    let roomCodeValue = "abc123"
    func testInitializer() {
        let roomCodeClassic = RoomCode(value: roomCodeValue, type: GameRoomType.ClassicRoom)
        XCTAssertEqual(roomCodeClassic.value, roomCodeValue)
        XCTAssertEqual(roomCodeClassic.type, GameRoomType.ClassicRoom)
        XCTAssertEqual(roomCodeClassic.type.rawValue, "classicRooms")

        let roomCodeCooperative = RoomCode(value: roomCodeValue, type: GameRoomType.CooperativeRoom)
        XCTAssertEqual(roomCodeCooperative.value, roomCodeValue)
        XCTAssertEqual(roomCodeCooperative.type, GameRoomType.CooperativeRoom)
        XCTAssertEqual(roomCodeCooperative.type.rawValue, "cooperativeRooms")
    }

    func testEqual() {
        let roomCodeClassic1 = RoomCode(value: roomCodeValue, type: GameRoomType.ClassicRoom)
        let roomCodeClassic2 = RoomCode(value: roomCodeValue, type: GameRoomType.ClassicRoom)
        XCTAssertEqual(roomCodeClassic1, roomCodeClassic2)

        let roomCodeCooperative = RoomCode(value: roomCodeValue, type: GameRoomType.CooperativeRoom)
        XCTAssertNotEqual(roomCodeClassic1, roomCodeCooperative)
    }
}
