//
//  CooperativeGameRoom.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class CooperativeGameRoom: GameRoom {
    override func createPlayer(from player: RoomPlayer) -> MultiplayerPlayer {
        CooperativePlayer(from: player)
    }
}
