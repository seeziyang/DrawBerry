//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGame {
    static let maxRounds = 5

    weak var delegate: ClassicGameDelegate?
    let networkAdapter: ClassicGameNetworkAdapter
    let roomCode: String
    let players: [ClassicPlayer]
    private let userIndex: Int // players contains user too
    var user: ClassicPlayer {
        players[userIndex]
    }
    private(set) var currentRound: Int
    var isLastRound: Bool {
        currentRound == ClassicGame.maxRounds
    }

    convenience init(from room: GameRoom) {
        self.init(from: room, networkAdapter: ClassicGameNetworkAdapter(roomCode: room.roomCode))
    }

    init(from room: GameRoom, networkAdapter: ClassicGameNetworkAdapter) {
        self.roomCode = room.roomCode
        self.networkAdapter = networkAdapter
        self.players = room.players.map { ClassicPlayer(from: $0) }
        let userUID = NetworkHelper.getLoggedInUserID()
        self.userIndex = self.players.firstIndex(where: { $0.uid == userUID }) ?? 0
        self.currentRound = 1
    }

    func moveToNextRound() {
        currentRound += 1
        // TODO: update db
    }

    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observePlayersDrawing() {
        for player in players where player !== user {
            networkAdapter.waitAndDownloadPlayerDrawing(
                playerUID: player.uid, forRound: currentRound, completionHandler: { [weak self] image in
                    player.addDrawing(image: image)

                    self?.delegate?.drawingsDidUpdate()
                }
            )
        }
    }
}
