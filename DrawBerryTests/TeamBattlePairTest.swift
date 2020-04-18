//
//  TeamBattlePairTest.swift
//  DrawBerryTests
//
//  Created by Calvin Chen on 18/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import XCTest
@testable import DrawBerry

class TeamBattlePairTest: XCTestCase {
    let player1 = RoomPlayer(name: "a", uid: "1")
    let player2 = RoomPlayer(name: "b", uid: "2")

    func testConstruct() {
        let drawer = TeamBattleDrawer(from: player1)
        let guesser = TeamBattleGuesser(from: player2)
        let team = TeamBattlePair(drawer: drawer, guesser: guesser)

        XCTAssertEqual(team.drawer, drawer, "Team drawer is wrong")
        XCTAssertEqual(team.guesser, guesser, "Team guesser is wrong")
        XCTAssertEqual(team.teamID, drawer.uid, "Team ID is wrong")
    }

    func testUpdateResult() {
        let drawer = TeamBattleDrawer(from: player1)
        let guesser = TeamBattleGuesser(from: player2)
        let team = TeamBattlePair(drawer: drawer, guesser: guesser)

        let testResult = TeamBattleTeamResult(resultID: "1")

        team.updateResult(testResult)

        XCTAssertEqual(team.result, testResult, "Team result is wrong")

    }

    func testUpdateWordList_emptyList() {
        let drawer = TeamBattleDrawer(from: player1)
        let guesser = TeamBattleGuesser(from: player2)
        let team = TeamBattlePair(drawer: drawer, guesser: guesser)

        let testList = WordList(words: [])
        team.updateWordList(testList)

        XCTAssertEqual(team.wordList, testList, "Team word list is wrong")
    }

    func testUpdateWordList_nonEmptyList() {
        let drawer = TeamBattleDrawer(from: player1)
        let guesser = TeamBattleGuesser(from: player2)
        let team = TeamBattlePair(drawer: drawer, guesser: guesser)

        let testList = WordList(databaseDescription: "dog")
        team.updateWordList(testList)

        XCTAssertEqual(team.wordList, testList, "Team word list is wrong")
    }

}
