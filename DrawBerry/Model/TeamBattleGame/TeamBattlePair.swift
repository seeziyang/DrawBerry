//
//  TeamBattlePair.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Foundation

class TeamBattlePair: Team {
    // Use drawer uid as team id
    var teamID: String
    var teamPlayers: [TeamBattlePlayer]
    var result: TeamBattleGameResult

    var drawer: TeamBattleDrawer
    var guesser: TeamBattleGuesser

    init(drawer: TeamBattleDrawer, guesser: TeamBattleGuesser) {
        self.teamID = drawer.uid
        self.drawer = drawer
        self.guesser = guesser
        self.teamPlayers = [drawer, guesser]
        self.result = TeamBattleGameResult()
    }

}
