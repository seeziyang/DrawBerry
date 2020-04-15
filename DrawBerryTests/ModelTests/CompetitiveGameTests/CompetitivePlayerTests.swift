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
    var firstPlayer, secondPlayer, firstPlayerDuplicate: CompetitivePlayer!
    let firstPlayerName = "playerOne", secondPlayerName = "playerTwo"

    override func setUp() {
        super.setUp()

        guard let canvas = CompetitiveBerryCanvas.createCompetitiveCanvas(
            within: CGRect(origin: CGPoint.zero, size: CGSize(width: 500, height: 500))) else {
                XCTFail("Failed to initialize canvas")
                return
        }

        firstPlayer = CompetitivePlayer(name: firstPlayerName, canvasDrawing: canvas)
        secondPlayer = CompetitivePlayer(name: secondPlayerName, canvasDrawing: canvas)
        firstPlayerDuplicate = CompetitivePlayer(name: firstPlayerName, canvasDrawing: canvas)
    }

    func testConstruct() {
        XCTAssertEqual(firstPlayer.name, firstPlayerName, "Player name is not initialized properly")
        XCTAssertEqual(firstPlayer.score, 0, "Player score is not initialized properly to 0")
        XCTAssertEqual(firstPlayer.extraStrokes, 0, "Initial player extra strokes is not correct")
        XCTAssertEqual(firstPlayer.votesLeft, CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE,
                       "Initial number of votes available is not correct")
        XCTAssertEqual(firstPlayer.votesGiven, 0, "Initial number of votes given is not correct")
        XCTAssertTrue(firstPlayer.hasVotedFor.isEmpty, "Initial player voted set is not empty")
    }

    func testEqual() {
        XCTAssertEqual(firstPlayer, firstPlayerDuplicate, "Players with same name are not equal")
    }

    func testNotEqual() {
        XCTAssertNotEqual(firstPlayer, secondPlayer, "Players with different names are equal")
    }

    func testSuccessfulVote() {
        firstPlayer.voteFor(player: secondPlayer)
        XCTAssertEqual(firstPlayer.votesLeft, CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE - 1,
                       "Number of votes left is not decremented")
        XCTAssertTrue(firstPlayer.hasVotedFor.contains(secondPlayer), "Set does not contain voted player")
        XCTAssertEqual(secondPlayer.votesGiven, CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE,
                       "Target player's votes given is not incremented" )
    }

    func testIsDoneVoting() {
        firstPlayer.votesLeft = 0
        XCTAssertTrue(firstPlayer.isDoneVoting, "Player is not done voting after using all votes")
    }

    func testResetVotes() {
        firstPlayer.voteFor(player: secondPlayer)
        firstPlayer.resetVotes()
        XCTAssertEqual(firstPlayer.votesLeft, CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE,
                       "Votes available is not correct after resetting votes")
        XCTAssertEqual(firstPlayer.votesGiven, 0, "Votes given is not correct after resetting votes")
        XCTAssertTrue(firstPlayer.hasVotedFor.isEmpty, "Voted set is not empty after resetting votes")
    }

    func testUnsuccessfulVote_votedForSelf() {
        let result = firstPlayer.voteFor(player: firstPlayer)
        XCTAssertEqual(result, Message.competitiveVotingCannotSelfVote, "Wrong result returned when voting for self")
        XCTAssertFalse(firstPlayer.hasVotedFor.contains(firstPlayer), "Set of voted contains self")
        XCTAssertEqual(firstPlayer.votesLeft, CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE,
                       "Votes was decremented when voting for self")
        XCTAssertEqual(firstPlayer.votesGiven, 0, "Votes given was incremented when voting for self")
    }

    func testUnsuccessfulVote_duplicateVotes() {
        firstPlayer.voteFor(player: secondPlayer)
        let result = firstPlayer.voteFor(player: secondPlayer)
        XCTAssertEqual(result, Message.competitiveVotingAlreadyVoted, "Wrong result returned when voting for self")
        XCTAssertEqual(firstPlayer.votesLeft, CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE - 1,
                       "Votes left is incorrect when voting for player who was already given vote")
        XCTAssertEqual(secondPlayer.votesGiven, CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE,
                       "Target player's votes given is incorrect after giving duplicate vote")
    }

    func testUnsuccessfulVote_noMoreVotesLeft() {
        firstPlayer.votesLeft = 0
        let result = firstPlayer.voteFor(player: secondPlayer)
        XCTAssertEqual(result, Message.competitiveVotingUsedAllVotes, "Wrong result returned when voting for self")
        XCTAssertEqual(firstPlayer.votesLeft, 0, "Votes left is incorrect after using all votes")
        XCTAssertFalse(firstPlayer.hasVotedFor.contains(secondPlayer),
                       "Player was able to vote even after using all votes")
        XCTAssertEqual(secondPlayer.votesGiven, 0,
                       "Target player's votes given was incremented after player has no more votes")
    }
}
