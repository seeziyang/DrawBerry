//
//  NetworkGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class NetworkGame {
    internal let gameNetwork: GameNetwork
    internal let roomCode: RoomCode

    init(from roomCode: RoomCode) {
        self.roomCode = roomCode
        self.gameNetwork = FirebaseGameNetworkAdapter(roomCode: roomCode)
    }

    init?(from roomCode: RoomCode, gameNetwork: GameNetwork) {
        if gameNetwork.roomCode != roomCode {
            return nil
        }
        self.roomCode = roomCode
        self.gameNetwork = gameNetwork
    }

    func upload(image: UIImage, for currentRound: Int) {
        gameNetwork.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observe(player: ComparablePlayer, for round: Int, completionHandler: @escaping (UIImage) -> Void) {
        observe(uid: player.uid, for: round, completionHandler: completionHandler)
    }

    func observe(uid: String, for round: Int, completionHandler: @escaping (UIImage) -> Void) {
        gameNetwork.observeAndDownloadPlayerDrawing(
            playerUID: uid, forRound: round, completionHandler: completionHandler)
    }

    func endGame(isRoomMaster: Bool, numRounds: Int) {
        gameNetwork.endGame(isRoomMaster: isRoomMaster, numRounds: numRounds)
    }
}
