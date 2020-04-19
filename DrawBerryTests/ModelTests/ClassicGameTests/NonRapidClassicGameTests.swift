//
//  NonRapidClassicGameTests.swift
//  DrawBerryTests
//
//  Created by See Zi Yang on 19/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class NonRapidClassicGameTests: XCTestCase {
    static let testRoomCode = RoomCode(value: "abc123", type: GameRoomType.ClassicRoom)
    static let testPlayers = [
        ClassicPlayer(name: "amy", uid: "amyyyy123", isRoomMaster: true),
        ClassicPlayer(name: "bob", uid: "boba456", isRoomMaster: false),
        ClassicPlayer(name: "can", uid: "cannot789", isRoomMaster: false)
    ]
    static let testTopics = ["round 1 topic", "round 2 topic", "round 3 topic",
                             "round 4 topic", "round 5 topic"]

    var nonRapidClassicGame = NonRapidClassicGame(roomCode: testRoomCode, players: testPlayers,
                                                  currentRound: 5, topics: testTopics)

    override func setUp() {
        super.setUp()

        nonRapidClassicGame = NonRapidClassicGame(roomCode: NonRapidClassicGameTests.testRoomCode,
                                                  players: NonRapidClassicGameTests.testPlayers,
                                                  currentRound: 5,
                                                  topics: NonRapidClassicGameTests.testTopics)
    }

    func testConstruct() {
        let nonRapidClassicGame = NonRapidClassicGame(roomCode: NonRapidClassicGameTests.testRoomCode,
                                                      players: NonRapidClassicGameTests.testPlayers,
                                                      currentRound: 5,
                                                      topics: NonRapidClassicGameTests.testTopics)

        XCTAssertEqual(nonRapidClassicGame.players, NonRapidClassicGameTests.testPlayers,
                       "NonRapidClassicGame's player is not constructed correctly")
        XCTAssertEqual(nonRapidClassicGame.user, NonRapidClassicGameTests.testPlayers[0],
                       "NonRapidClassicGame's user is not constructed correctly")
        XCTAssertEqual(nonRapidClassicGame.currentRound, 5,
                       "NonRapidClassicGame's currentRound is not constructed correctly")
        XCTAssertEqual(nonRapidClassicGame.maxRounds, .max,
                       "NonRapidClassicGame's maxRounds is not constructed correctly")
        XCTAssertEqual(nonRapidClassicGame.roundMaster, NonRapidClassicGameTests.testPlayers[1],
                       "NonRapidClassicGame's roundMaster is not constructed correctly")
    }

    func testHasAllPlayersDrawnForCurrentRound() {
        XCTAssertFalse(nonRapidClassicGame.hasAllPlayersDrawnForCurrentRound(),
                       "NonRapidClassicGame's hasAllPlayersDrawnForCurrentRound is not correct")

        nonRapidClassicGame.players.forEach { $0.addDrawing(image: UIImage()) }
        XCTAssertTrue(nonRapidClassicGame.hasAllPlayersDrawnForCurrentRound(),
                      "NonRapidClassicGame's hasAllPlayersDrawnForCurrentRound is not correct")
    }
}
