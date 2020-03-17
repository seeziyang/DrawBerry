//
//  GameRoom.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Foundation

class GameRoom {
    static let maxPlayers = 8

    private(set) var players: [RoomPlayer]
    let roomCode: String

    init(roomCode: String) {
        self.roomCode = roomCode
        players = []
    }
}
