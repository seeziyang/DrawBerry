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
    var wordList: WordList? {
        didSet {
            guesser.wordList = wordList
        }
    }

    /// Constructs a `TeamBattlePair` from a `TeamBattleDrawer` and `TeamBattleDrawer`.
    init(drawer: TeamBattleDrawer, guesser: TeamBattleGuesser) {
        self.teamID = drawer.uid
        self.drawer = drawer
        self.guesser = guesser
        self.teamPlayers = [drawer, guesser]
        self.result = TeamBattleTeamResult(resultID: teamID)
    }

    /// Updates the team result after successful retrieval by network.
    func updateResult(_ result: TeamBattleTeamResult) {
        self.result = result
    }

    /// Updates the team word list after successful retrieval by network.
    func updateWordList(_ list: WordList) {
        self.wordList = list
    }

}
