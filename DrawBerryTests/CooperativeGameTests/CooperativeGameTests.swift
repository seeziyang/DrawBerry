//
//  CooperativeGameTests.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 16/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
import Firebase
@testable import DrawBerry

class CooperativeGameTests: XCTestCase {
    var cooperativeGame: CooperativeGame!
    static let testRoomCode = RoomCode(value: "testroom", type: .CooperativeRoom)
    let roomNetwork = RoomNetworkStub(roomCode: testRoomCode)

    override func setUp() {
        super.setUp()
        roomNetwork.deleteRoom()
    }

    override func tearDown() {
        super.tearDown()
        roomNetwork.deleteRoom()
    }

    func testConstructor() {
        let gameRoom = CooperativeGameRoomStub(roomCode: CooperativeGameTests.testRoomCode, roomNetwork: roomNetwork)
        cooperativeGame = CooperativeGame(from: gameRoom)
        XCTAssertEqual(cooperativeGame.players, gameRoom.players)
        XCTAssertTrue(cooperativeGame.allDrawings.isEmpty)
    }
}
