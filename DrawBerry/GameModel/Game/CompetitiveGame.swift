//
//  CompetitiveGame.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Foundation

// MARK: TODOS
// 1. Timer
// 2. Categories
// 3. Player names?
// 4. Display current round

struct CompetitiveGame {
    static let MAX_ROUNDS = 5
    static let MAX_STROKES_PER_PLAYER = 1
    static let TIME_PER_ROUND = 3 // Set to small number for testing purposes

    var players = [Player]()
    var currentRound = 1
}
