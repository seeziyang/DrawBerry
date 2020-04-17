//
//  Game.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol Game {
    associatedtype GamePlayer: Player

    var players: [GamePlayer] { get }
    var currentRound: Int { get set }
}
