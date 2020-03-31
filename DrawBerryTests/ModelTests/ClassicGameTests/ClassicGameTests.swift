//
//  ClassicGameTests.swift
//  DrawBerryTests
//
//  Created by See Zi Yang on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class ClassicGameTests: XCTestCase {
    static let roomCode = RoomCode(value: "abc123", type: GameRoomType.ClassicRoom)
    var classicGame = ClassicGame(
        from: GameRoom(roomCode: ClassicGameTests.roomCode),
        networkAdapter: GameNetworkAdapterStub(roomCode: ClassicGameTests.roomCode))

    override func setUp() {
        super.setUp()

        classicGame = ClassicGame(
            from: GameRoom(roomCode: ClassicGameTests.roomCode),
            networkAdapter: GameNetworkAdapterStub(roomCode: ClassicGameTests.roomCode))
    }

//    func testConstruct() {
//        let classicGame = ClassicGame(
//            from: GameRoom(roomCode: ClassicGameTests.roomCode),
//            networkAdapter: GameNetworkAdapterStub(roomCode: ClassicGameTests.roomCode))
//
//        XCTAssertEqual(classicGame.roomCode, ClassicGameTests.roomCode,
//                       "ClassicGame's roomCode is not constructed properly")
//        XCTAssertTrue(classicGame.players.isEmpty,
//                      "ClassicGame's players is not constructed properly")
//        XCTAssertEqual(classicGame.currentRound, 1,
//                       "ClassicGame's currentRound is not constructed properly")
//    }
//
//    func testMoveToNextRound() {
//        classicGame.moveToNextRound()
//        XCTAssertEqual(classicGame.currentRound, 2, "ClassicGame's moveToNextRound is not correct")
//
//        classicGame.moveToNextRound()
//        XCTAssertEqual(classicGame.currentRound, 3, "ClassicGame's moveToNextRound is not correct")
//    }
}
