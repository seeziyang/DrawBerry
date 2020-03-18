//
//  GameRoom.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class GameRoom {
    static let maxPlayers = 8

    weak var delegate: GameRoomDelegate?
    let networkRoomHelper: NetworkRoomHelper
    let roomCode: String
    private(set) var players: [RoomPlayer]

    init(roomCode: String) {
        self.networkRoomHelper = NetworkRoomHelper()
        self.roomCode = roomCode
        self.players = []

        networkRoomHelper.observeRoomPlayers(roomCode: roomCode, listener: { [weak self] players in
            self?.players = players
            self?.delegate?.playersDidUpdate()
        })
    }
}
