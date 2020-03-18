//
//  CompetitiveGame.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

// MARK: TODO
// 1. Timer
// 2. Categories
// 3. Player names?
// 4. Display current round

struct CompetitiveGame {
    static let MAX_ROUNDS = 5
    static let STROKES_PER_PLAYER = 1
    static let TIME_PER_ROUND = 45

    var players = [Player]()
    var powerupManager = PowerupManager()

    var currentRound = 1

    var currentPowerups: [Powerup] {
        powerupManager.allPowerups
    }

    func rollForPowerups() {
        powerupManager.rollForPowerup(for: players)
    }
}
