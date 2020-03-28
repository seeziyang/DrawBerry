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
        let gameRoom = GameRoom(roomCode: roomCode, roomNetworkAdapter: RoomNetworkAdapterStub())

        XCTAssertEqual(gameRoom.roomCode, roomCode, "GameRoom's roomCode is not constructed properly")
        XCTAssertTrue(gameRoom.players.isEmpty, "GameRoom's players is not constructed properly")
        XCTAssertEqual(gameRoom.status, .enterable, "GameRoom's status is not correct")
        XCTAssertFalse(gameRoom.canStart, "GameRoom's canStart is not correct")
    }
}

class RoomNetworkAdapterStub: RoomNetworkAdapter {
    override func createRoom(roomCode: RoomCode) {
    }

    override func checkRoomExists(roomCode: RoomCode, completionHandler: @escaping (Bool) -> Void) {
    }

    override func checkRoomEnterable(roomCode: RoomCode,
                                     completionHandler: @escaping (GameRoomStatus) -> Void) {
    }

    override func joinRoom(roomCode: RoomCode) {
    }

    override func observeRoomPlayers(roomCode: RoomCode, listener: @escaping ([RoomPlayer]) -> Void) {
    }
}
