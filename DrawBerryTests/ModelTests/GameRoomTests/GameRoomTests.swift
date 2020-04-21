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
    static let testRoomCode = RoomCode(value: "123abc", type: GameRoomType.ClassicRoom)
    var gameRoom = GameRoom(roomCode: GameRoomTests.testRoomCode,
                            roomNetwork: RoomNetworkStub(roomCode: GameRoomTests.testRoomCode))

    override func setUp() {
        super.setUp()
        self.gameRoom = GameRoom(roomCode: GameRoomTests.testRoomCode,
                                 roomNetwork: RoomNetworkStub(roomCode: GameRoomTests.testRoomCode))
    }

    func testConstruct() {
        let roomCode = GameRoomTests.testRoomCode
        let gameRoom = GameRoom(roomCode: roomCode, roomNetwork: RoomNetworkStub(roomCode: roomCode))

        XCTAssertEqual(gameRoom.roomCode, roomCode, "GameRoom's roomCode is not constructed properly")
        XCTAssertTrue(gameRoom.players.isEmpty, "GameRoom's players is not constructed properly")
        XCTAssertEqual(gameRoom.status, .enterable, "GameRoom's status is not correct")
        XCTAssertFalse(gameRoom.canStart, "GameRoom's canStart is not correct")
        XCTAssertTrue(gameRoom.isRapid, "GameRoom's isRapid is not constructed properly")
    }

    func testToggleIsRapid() {
        XCTAssertTrue(gameRoom.isRapid, "GameRoom's isRapid is not constructed properly")

        gameRoom.toggleIsRapid()
        XCTAssertFalse(gameRoom.isRapid, "GameRoom's toggleIsRapid is not correct")

        gameRoom.toggleIsRapid()
        XCTAssertTrue(gameRoom.isRapid, "GameRoom's toggleIsRapid is not correct")
    }
}
