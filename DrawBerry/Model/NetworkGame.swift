//
//  NetworkGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class NetworkGame {
    internal let networkAdapter: GameNetworkAdapter
    internal let roomCode: RoomCode

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

    func observe(player: ComparablePlayer, for round: Int, completionHandler: @escaping (UIImage) -> Void) {
        observe(uid: player.uid, for: round, completionHandler: completionHandler)
    }

    func observe(uid: String, for round: Int, completionHandler: @escaping (UIImage) -> Void) {
        networkAdapter.waitAndDownloadPlayerDrawing(
            playerUID: uid, forRound: round, completionHandler: completionHandler)
    }

    func endGame(isRoomMaster: Bool, numRounds: Int) {
        networkAdapter.endGame(isRoomMaster: isRoomMaster, numRounds: numRounds)
    }
}
