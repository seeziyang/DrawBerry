//
//  TeamBattleTeamResultTests.swift
//  DrawBerryTests
//
//  Created by Calvin Chen on 18/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class TeamBattleTeamResultTests: XCTestCase {
    let player1 = RoomPlayer(name: "a", uid: "1")
    let player2 = RoomPlayer(name: "b", uid: "2")

    let testResult = TeamBattleTeamResult(resultID: "1", correctGuess: 0, incorrectGuess: 0)

    func testConstruct_fromDatabase() {
        let databaseDescription = "1/0/0"

        let constructedResult = TeamBattleTeamResult(databaseDescription: databaseDescription)!

        XCTAssertEqual(testResult, constructedResult, "Result constructed from database is wrong")
        XCTAssertEqual(testResult, constructedResult, "Result constructed from database is wrong")
    }

    func testConstruct_fromID() {
        let testID = "1"
        let constructedResult = TeamBattleTeamResult(resultID: testID)

        XCTAssertEqual(constructedResult.resultID, testID)
        XCTAssertEqual(constructedResult.correctGuess, 0)
        XCTAssertEqual(constructedResult.incorrectGuess, 0)
    }

    func testAddCorrectGuess() {
        let testID = "1"
        let teamResult = TeamBattleTeamResult(resultID: testID)

        teamResult.addCorrectGuess()

        XCTAssertEqual(teamResult.resultID, testID)
        XCTAssertEqual(teamResult.correctGuess, 1)
        XCTAssertEqual(teamResult.incorrectGuess, 0)
    }

    func testAddIncorrectGuess() {
        let testID = "1"
        let teamResult = TeamBattleTeamResult(resultID: testID)

        teamResult.addIncorrectGuess()

        XCTAssertEqual(teamResult.resultID, testID)
        XCTAssertEqual(teamResult.correctGuess, 0)
        XCTAssertEqual(teamResult.incorrectGuess, 1)
    }

    func testGetDatabaseDescription() {
        let testID = "1"
        let teamResult = TeamBattleTeamResult(resultID: testID)

        XCTAssertEqual(teamResult.getDatabaseStorageDescription(), "1/0/0")

    }

    func testGetDisplayDescription() {
        let testID = "1"
        let teamResult = TeamBattleTeamResult(resultID: testID)

        let description = "Team Result: \n" +
        " Correct guesses: \(0)\n" +
            "Incorrect guesses: \(0)\n"
            + "Score: \(teamResult.calculateScore())\n"

        XCTAssertEqual(teamResult.getDisplayDescription(), description)

    }

}
