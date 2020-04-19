//
//  GameNetworkAdapterStub.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 29/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit
import XCTest

class GameNetworkStub: GameNetwork {
    let roomCode: RoomCode
    var expectation: XCTestExpectation?

    init(roomCode: RoomCode) {
        self.roomCode = roomCode
    }

    func setExpectation(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func uploadUserDrawing(image: UIImage, forRound round: Int) {
        expectation?.fulfill()
    }

    func observeAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                         completionHandler: @escaping (UIImage) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            completionHandler(UIImage())
            self.expectation?.fulfill()
        })
    }

    func userVoteFor(playerUID: String, forRound round: Int,
                     updatedPlayerPoints: Int, updatedUserPoints: Int?) {
    }

    func observePlayerVote(playerUID: String, forRound round: Int,
                           completionHandler: @escaping (String) -> Void) {
    }

    func endGame(isRoomMaster: Bool, numRounds: Int) {
        expectation?.fulfill()
    }

    func observeAndDownloadTeamResult(playerUID: String,
                                      completionHandler: @escaping (TeamBattleTeamResult) -> Void) {
    }

    func uploadTeamResult(result: TeamBattleTeamResult) {
    }

    func getLoggedInUserID() -> String? {
        TestConstants.admin3_Cooperative.uid
    }

    func setTopic(topic: String, forRound round: Int) {
    }

    func observeTopic(forRound round: Int, completionHandler: @escaping (String) -> Void) {
    }

    func getLoggedInUserName() -> String? {
        nil
    }
}
