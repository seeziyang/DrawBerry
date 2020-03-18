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

    var players = [Player]()

    var currentRound = 1
}
