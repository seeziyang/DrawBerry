//
//  ClassicGameRoom.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class ClassicGameRoom: GameRoom {
    override func createPlayer(from player: RoomPlayer) -> MultiplayerPlayer {
        ClassicPlayer(from: player)
    }
}
