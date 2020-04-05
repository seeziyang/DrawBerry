//
//  GameRoomTests.swift
//  DrawBerryTests
//
//  Created by See Zi Yang on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class GameRoomTests: XCTestCase {
    func testConstruct() {
        let roomCode = RoomCode(value: "123abc", type: GameRoomType.ClassicRoom)
        let gameRoom = GameRoom(roomCode: roomCode, roomNetworkAdapter: RoomNetworkAdapterStub(roomCode: roomCode))

        XCTAssertEqual(gameRoom.roomCode, roomCode, "GameRoom's roomCode is not constructed properly")
        XCTAssertTrue(gameRoom.players.isEmpty, "GameRoom's players is not constructed properly")
        XCTAssertEqual(gameRoom.status, .enterable, "GameRoom's status is not correct")
        XCTAssertFalse(gameRoom.canStart, "GameRoom's canStart is not correct")
    }
}

class RoomNetworkAdapterStub: RoomNetworkAdapter {
    override func observeRoomPlayers(listener: @escaping ([RoomPlayer]) -> Void) {
    }
}
