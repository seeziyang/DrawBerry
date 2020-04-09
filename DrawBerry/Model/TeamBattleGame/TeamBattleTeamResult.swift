//
//  TeamBattleTeamResult.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleTeamResult {

    let resultID: String
    let scoreForCorrectGuess = 100
    let scoreForIncorrectGuess = -10

    var correctGuess = 0
    var incorrectGuess = 0

    init(resultID: String) {
        self.resultID = resultID
    }

    func addCorrectGuess() {
        correctGuess += 1
    }

    func addincorrectGuess() {
        incorrectGuess += 1
    }

    func calculateScore() -> Int {
        return correctGuess * scoreForCorrectGuess
            + incorrectGuess * scoreForIncorrectGuess
    }
}
