//
//  MultiplayerNetworkGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class MultiplayerNetworkGame: NetworkGame, MultiplayerGame {
    var players: [MultiplayerPlayer]
    var user: MultiplayerPlayer
    var allDrawings: [UIImage] = []
    var currentRound: Int
    let maxRounds: Int
    var isLastRound: Bool {
        currentRound == maxRounds
    }

    init(from room: GameRoom, maxRounds: Int) {
        let players = room.players.sorted().map { room.createPlayer(from: $0) }
        self.players = players
        self.user = players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? players[0]
        self.maxRounds = maxRounds
        self.currentRound = 1
        super.init(from: room.roomCode)
    }

    init?(from room: GameRoom, maxRounds: Int, gameNetwork: GameNetwork) {
        let players = room.players.sorted().map { room.createPlayer(from: $0) }
        self.players = players
        self.user = players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? players[0]
        self.maxRounds = maxRounds
        self.currentRound = 1
        super.init(from: room.roomCode, gameNetwork: gameNetwork)
    }

    init(from roomCode: RoomCode, players: [ClassicPlayer], currentRound: Int) {
        self.players = players.sorted()
        self.user = players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? players[0]
        self.maxRounds = .max
        self.currentRound = currentRound
        super.init(from: roomCode)
    }

    /// Adds a `UIImage` to the associated user.
    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        upload(image: image, for: currentRound)
    }

    func getIndex(of player: MultiplayerPlayer) -> Int? {
        players.firstIndex(where: { $0.uid == player.uid })
    }
}
