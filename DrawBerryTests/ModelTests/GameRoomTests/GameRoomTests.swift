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
        let gameRoom = GameRoom(roomCode: "123abc", roomNetworkAdapter: RoomNetworkAdapterStub())

        XCTAssertEqual(gameRoom.roomCode, "123abc", "GameRoom's roomCode is not constructed properly")
        XCTAssertTrue(gameRoom.players.isEmpty, "GameRoom's players is not constructed properly")
        XCTAssertFalse(gameRoom.canStart, "GameRoom's canStart is not correct")
    }
}

class RoomNetworkAdapterStub: RoomNetworkAdapter {
    override func createRoom(roomCode: String) {
    }

    override func checkRoomExists(roomCode: String, completionHandler: @escaping (Bool) -> Void) {
    }

    override func checkRoomEnterable(roomCode: String,
                                     completionHandler: @escaping (GameRoomStatus) -> Void) {
    }

    override func joinRoom(roomCode: String) {
    }

    override func observeRoomPlayers(roomCode: String, listener: @escaping ([RoomPlayer]) -> Void) {
    }
}
