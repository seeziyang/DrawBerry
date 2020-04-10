//
//  TeamBattleGameRoom.swift
//  DrawBerry
//
//  Created by Calvin Chen on 10/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleGameRoom: GameRoom {

    override var canStart: Bool {
        players.count >= 2 && players.count <= GameRoom.maxPlayers && players.count.isMultiple(of: 2)
    }
}
