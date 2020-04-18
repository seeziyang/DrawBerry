//
//  NetworkGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

protocol NetworkGame: Game {
    var gameNetwork: GameNetwork { get }
    var roomCode: RoomCode { get }
}

extension NetworkGame {
    func upload(image: UIImage, for currentRound: Int) {
        gameNetwork.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observe<T: ComparablePlayer>(player: T, for round: Int,
                                      completionHandler: @escaping (UIImage) -> Void) {
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
