//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class ClassicGame {
    static let maxRounds = 5

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

    init(from room: GameRoom) {
        self.roomCode = room.roomCode
        self.players = room.players.map { ClassicPlayer(from: $0) }
        let userUID = NetworkHelper.getLoggedInUserID()
        self.userIndex = self.players.firstIndex(where: { $0.uid == userUID }) ?? 0
        self.currentRound = 1
    }

    func moveToNextRound() {
        currentRound += 1
    }
}
