//
//  GameNetworkAdapterStub.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 29/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class GameNetworkStub: GameNetwork {
    let roomCode: RoomCode

    init(roomCode: RoomCode) {
        self.roomCode = roomCode
    }

    func uploadUserDrawing(image: UIImage, forRound round: Int) {
    }

    func observeAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                         completionHandler: @escaping (UIImage) -> Void) {
    }

    func userVoteFor(playerUID: String, forRound round: Int,
                     updatedPlayerPoints: Int, updatedUserPoints: Int?) {
    }

    func observePlayerVote(playerUID: String, forRound round: Int,
                           completionHandler: @escaping (String) -> Void) {
    }

    func endGame(isRoomMaster: Bool, numRounds: Int) {
    }

    func observeValue(key: String, playerUID: String,
                      completionHandler: @escaping (String) -> Void) {

    }

    func uploadKeyValuePair(key: String, playerUID: String, value: String) {
    }

    func setTopic(topic: String, forRound round: Int) {
    }

    func observeTopic(forRound round: Int, completionHandler: @escaping (String) -> Void) {
    }
}
