//
//  TeamBattleGameResult.swift
//  DrawBerry
//
//  Created by Calvin Chen on 9/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleGameResult {
    var teamResults = [TeamBattleTeamResult]()

    init() {

    }

    func addTeamResult(result: TeamBattleTeamResult) {
        teamResults.append(result)
    }

    func getWinnerTeamID() -> String? {
        return teamResults.first?.resultID
    }

    func topRankingTeams() -> [TeamBattlePair] {
        return []
    }
}
