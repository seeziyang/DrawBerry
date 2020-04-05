//
//  CompetitiveGame.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

struct CompetitiveGame: Game {
    static let MAX_ROUNDS = 5
    static let STROKES_PER_PLAYER = 1

    static let TIME_PER_ROUND = 45
    static let TIME_AFTER_POWERUPS_SPAWN = 10
    static let MIN_TIME_POWERUPS_SPAWN = 5

    static let FIRST_PLACE_SCORE = 50
    static let SECOND_PLACE_SCORE = 20

    static let NEXT_BUTTON = #imageLiteral(resourceName: "next")

    var players = [CompetitivePlayer]()

    var currentRound = 1
    var isGameOver: Bool {
        currentRound > CompetitiveGame.MAX_ROUNDS
    }

    mutating func nextRound() {
        currentRound += 1
    }
}
