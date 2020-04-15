//
//  CompetitiveGameTests.swift
//  DrawBerryTests
//
//  Created by Jon Chua on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class CompetitiveGameTests: XCTestCase {
    var competitiveGame: CompetitiveGame!

    override func setUp() {
        super.setUp()
        competitiveGame = CompetitiveGame()
    }

    func testConstruct() {
        XCTAssertEqual(competitiveGame.players.count, 0, "Initial player count is not 0")
        XCTAssertEqual(competitiveGame.currentRound, 1, "Initial round is not 1")
    }

    func testNextRound() {
        let currentRound = competitiveGame.currentRound
        competitiveGame.nextRound()
        XCTAssertEqual(competitiveGame.currentRound, currentRound + 1, "Next round does not increment currentRound")
    }

    func testGameOver() {
        let rounds = CompetitiveGame.MAX_ROUNDS
        for _ in 1...rounds {
            XCTAssertFalse(competitiveGame.isGameOver, "Game is over before \(rounds) rounds")
            competitiveGame.nextRound()
        }
        XCTAssertTrue(competitiveGame.isGameOver, "Game is not over after \(rounds) rounds")
    }
}
