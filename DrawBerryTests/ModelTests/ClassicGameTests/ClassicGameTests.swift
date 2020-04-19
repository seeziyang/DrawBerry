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
    static let testRoomCode = RoomCode(value: "abc123", type: GameRoomType.ClassicRoom)
    static let testGameRoom = GameRoomStub(roomCode: testRoomCode)

    var classicGame = ClassicGame(from: ClassicGameTests.testGameRoom)

    override func setUp() {
        super.setUp()

        classicGame = ClassicGame(from: ClassicGameTests.testGameRoom)
    }

    func testConstruct() {
        let classicGame = ClassicGame(from: ClassicGameTests.testGameRoom)

        XCTAssertEqual(classicGame.roomCode, ClassicGameTests.testRoomCode,
                       "ClassicGame's roomCode is not constructed properly")
        XCTAssertEqual(classicGame.players.count, 3,
                       "ClassicGame's players is not constructed properly")
        XCTAssertEqual(classicGame.currentRound, 1,
                       "ClassicGame's currentRound is not constructed properly")
        XCTAssertEqual(classicGame.maxRounds, 9,
                       "ClassicGame's maxRounds is not constructed properly")
    }

    func testHasAllPlayersDrawnForCurrentRound() {
        classicGame.players.forEach { $0.addDrawing(image: UIImage()) }

        XCTAssertTrue(classicGame.hasAllPlayersDrawnForCurrentRound(),
                      "ClassicGame's hasAllPlayersDrawnForCurrentRound is not correct")
    }

    func testHasAllPlayersVotedForCurrentRound() {
        let numPlayers = classicGame.players.count
        for i in 0..<numPlayers {
            classicGame.players[i].voteFor(player: classicGame.players[(i + 1) % numPlayers])
        }

        XCTAssertTrue(classicGame.hasAllPlayersVotedForCurrentRound(),
                      "ClassicGame's hasAllPlayersDrawnForCurrentRound is not correct")
    }

    func testUserVoteFor() {
        classicGame.userVoteFor(player: classicGame.players[1])

        XCTAssertEqual(classicGame.user.points, 0,
                       "ClassicGame's userVoteFor is not correct")
        XCTAssertEqual(classicGame.players[1].points, ClassicGame.votingPoints,
                       "ClassicGame's userVoteFor is not correct")
    }

    func testAddFirstRoundTopic() {
        classicGame.addFirstRoundTopic("my topic")

        XCTAssertEqual(classicGame.getCurrentRoundTopic(), "my topic",
                       "ClassicGame's addFirstRoundTopic is not correct")
    }
}
