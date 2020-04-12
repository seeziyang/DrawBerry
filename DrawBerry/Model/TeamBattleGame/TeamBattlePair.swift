//
//  TeamBattlePair.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattlePair: Team {
    // Use drawer uid as team id
    var teamID: String
    var teamPlayers: [TeamBattlePlayer]
    var result: TeamBattleTeamResult

    let drawer: TeamBattleDrawer
    let guesser: TeamBattleGuesser
    var drawings = [UIImage]()

    init(drawer: TeamBattleDrawer, guesser: TeamBattleGuesser) {
        self.teamID = drawer.uid
        self.drawer = drawer
        self.guesser = guesser
        self.teamPlayers = [drawer, guesser]
        self.result = TeamBattleTeamResult(resultID: teamID)
    }

    func updateResult(_ result: TeamBattleTeamResult) {
        self.result = result
    }

}
