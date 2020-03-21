//
//  CompetitivePlayerTests.swift
//  DrawBerryTests
//
//  Created by Jon Chua on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class CompetitivePlayerTests: XCTestCase {
    func testConstruct() {
        let playerName = "player"
        let player = CompetitivePlayer(name: playerName, canvasDrawing: BerryCanvas())

        XCTAssertEqual(player.name, playerName, "Player name is not initialized properly")
        XCTAssertEqual(player.extraStrokes, 0, "Initial player extra strokes is not correct")
    }

    func testEqual() {
        let playerName = "player"
        let firstPlayer = CompetitivePlayer(name: playerName, canvasDrawing: BerryCanvas())
        let secondPlayer = CompetitivePlayer(name: playerName, canvasDrawing: BerryCanvas())

        XCTAssertEqual(firstPlayer, secondPlayer, "Players with same name are not equal")
    }

    func testNotEqual() {
        let firstPlayerName = "playerOne"
        let secondPlayerName = "playerTwo"

        let firstPlayer = CompetitivePlayer(name: firstPlayerName, canvasDrawing: BerryCanvas())
        let secondPlayer = CompetitivePlayer(name: secondPlayerName, canvasDrawing: BerryCanvas())

        XCTAssertNotEqual(firstPlayer, secondPlayer, "Players with different names are equal")
    }
}
