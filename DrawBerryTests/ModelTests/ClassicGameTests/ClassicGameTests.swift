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
    var classicGame = ClassicGame(from: GameRoom(roomCode: "abc123"),
                                  networkAdapter: ClassicGameNetworkAdapterStub(roomCode: "abc123"))

    override func setUp() {
        super.setUp()

        classicGame = ClassicGame(from: GameRoom(roomCode: "abc123"),
                                  networkAdapter: ClassicGameNetworkAdapterStub(roomCode: "abc123"))
    }

    func testConstruct() {
        let classicGame = ClassicGame(from: GameRoom(roomCode: "abc123"),
                                      networkAdapter: ClassicGameNetworkAdapterStub(roomCode: "abc123"))

        XCTAssertEqual(classicGame.roomCode, "abc123",
                       "ClassicGame's roomCode is not constructed properly")
        XCTAssertTrue(classicGame.players.isEmpty,
                      "ClassicGame's players is not constructed properly")
        XCTAssertEqual(classicGame.currentRound, 1,
                       "ClassicGame's currentRound is not constructed properly")
    }

    func testMoveToNextRound() {
        classicGame.moveToNextRound()
        XCTAssertEqual(classicGame.currentRound, 2, "ClassicGame's moveToNextRound is not correct")

        classicGame.moveToNextRound()
        XCTAssertEqual(classicGame.currentRound, 3, "ClassicGame's moveToNextRound is not correct")
    }
}

class ClassicGameNetworkAdapterStub: ClassicGameNetworkAdapter {
    override func uploadUserDrawing(image: UIImage, forRound round: Int) {
    }

    override func waitAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                               completionHandler: @escaping (UIImage) -> Void) {
    }
}
