//
//  MultiplayerNetworkGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class MultiplayerNetworkGame<T: MultiplayerPlayer>: NetworkGame, MultiplayerGame {
    var players: [T]
    var user: T

    var currentRound: Int
    var maxRounds: Int
    var isLastRound: Bool {
        currentRound == maxRounds
    }

    var gameNetwork: GameNetwork
    var roomCode: RoomCode

    init(from room: GameRoom, maxRounds: Int) {
        let players = room.players.sorted().map { T(from: $0) }
        self.players = players
        let gameNetwork = FirebaseGameNetworkAdapter(roomCode: room.roomCode)
        self.gameNetwork = gameNetwork
        self.user = players.first(where: { $0.uid == gameNetwork.getLoggedInUserID() })
            ?? players[0]
        self.currentRound = 1
        self.maxRounds = maxRounds
        self.roomCode = room.roomCode
    }

    init(from roomCode: RoomCode, players: [T], currentRound: Int, maxRounds: Int) {
        self.players = players.sorted()
        let gameNetwork = FirebaseGameNetworkAdapter(roomCode: roomCode)
        self.gameNetwork = gameNetwork
        self.user = players.first(where: { $0.uid == gameNetwork.getLoggedInUserID() })
            ?? players[0]
        self.currentRound = currentRound
        self.maxRounds = maxRounds
        self.roomCode = roomCode
    }

    /// Sets the game network of the `MultiplayerNetworkGame`.
    /// If the given network's `RoomCode` is inconsistent with the game's `RoomCode`,
    /// do nothing.
    func setGameNetwork(to network: GameNetwork) {
        if network.roomCode != roomCode {
            return
        }
        self.gameNetwork = network
        self.user = players.first(where: { $0.uid == network.getLoggedInUserID() }) ?? players[0]
    }

    /// Adds the given `UIImage` to the user.
    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        upload(image: image, for: currentRound)
    }

    /// Returns the index of the given `GamePlayer`.
    func getIndex(of player: T) -> Int? {
        players.firstIndex(where: { $0.uid == player.uid })
    }
}
