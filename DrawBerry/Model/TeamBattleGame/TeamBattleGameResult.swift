//
//  TeamBattleGameResult.swift
//  DrawBerry
//
//  Created by Calvin Chen on 9/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleGameResult {
    let numberOfTeams: Int
    var teamResults = Set<TeamBattleTeamResult>()

    var sortedTeamResults: [TeamBattleTeamResult] {
        return teamResults.sorted()
    }

    init(numberOfTeams: Int) {
        self.numberOfTeams = numberOfTeams
    }

    func didGameFinish() -> Bool {
        return teamResults.count == numberOfTeams
    }

    func updateTeamResult(_ result: TeamBattleTeamResult) {
        teamResults.insert(result)
    }

    func getRank(team: Team) -> Int? {
        for i in 0..<sortedTeamResults.count where sortedTeamResults[i].resultID == team.teamID {
            return i + 1
        }
        return nil
    }

}
