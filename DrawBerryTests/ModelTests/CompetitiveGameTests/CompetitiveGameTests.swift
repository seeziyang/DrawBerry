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
}
