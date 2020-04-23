//
//  TeamBattleGuesser.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleGuesser: TeamBattlePlayer {

    var wordList: WordList?

    /// Gets the topic word for a game round.
    private func getDrawingTopic(for round: Int) -> String? {
        return wordList?.getWord(at: round - 1)?.value
    }

    /// Gets the length of topic word for a game round.
    func getLengthHint(for round: Int) -> Int? {
        return getDrawingTopic(for: round)?.count
    }

    /// Checks if a guess for a game round is correct.
    func isGuessCorrect(guess: String, for round: Int) -> Bool {

        guard let word = getDrawingTopic(for: round) else {
            return false
        }
        return guess == word
    }

}
