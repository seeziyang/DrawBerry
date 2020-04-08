//
//  NetworkGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class NetworkGame {
    typealias GamePlayer = ComparablePlayer

    private let networkAdapter: GameNetworkAdapter
    private let roomCode: RoomCode

    init(from roomCode: RoomCode) {
        self.roomCode = roomCode
        self.networkAdapter = GameNetworkAdapter(roomCode: roomCode)
    }

    init?(from roomCode: RoomCode, networkAdapter: GameNetworkAdapter) {
        if networkAdapter.roomCode != roomCode {
            return nil
        }
        self.roomCode = roomCode
        self.networkAdapter = networkAdapter
    }

    func upload(image: UIImage, for currentRound: Int) {
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observe(player: GamePlayer, for round: Int, completionHandler: @escaping (UIImage) -> Void) {
        networkAdapter.waitAndDownloadPlayerDrawing(
            playerUID: player.uid, forRound: round, completionHandler: completionHandler)
    }

    func voteFor(player: ClassicPlayer, for round: Int, updatedPlayerPoints: Int) {
        networkAdapter.userVoteFor(playerUID: player.uid, forRound: round, updatedPlayerPoints: player.points)
    }

    func observePlayerVote(player: ClassicPlayer, for round: Int, completionHandler: @escaping (String) -> Void) {
        networkAdapter.observePlayerVote(playerUID: player.uid, forRound: round, completionHandler: completionHandler)
    }

    func endGame(isRoomMaster: Bool, numRounds: Int) {
        networkAdapter.endGame(isRoomMaster: isRoomMaster, numRounds: numRounds)
    }
}
