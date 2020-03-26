//
//  CompetitiveGame.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct CompetitiveGame {
    static let MAX_ROUNDS = 5
    static let STROKES_PER_PLAYER = 1
    static let TIME_PER_ROUND = 45
    static let TIME_AFTER_POWERUPS_SPAWN = 0

    var players = [CompetitivePlayer]()

    var currentRound = 1
}
