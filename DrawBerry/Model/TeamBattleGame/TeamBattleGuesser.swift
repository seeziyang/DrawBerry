//
//  TeamBattleGuesser.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleGuesser: TeamBattlePlayer {

    var wordList: WordList?

    func getDrawingTopic(for round: Int) -> String {
        // TODO: use network
        return wordList?.getWord(at: round - 1)?.value ?? ""
    }

    func getLengthHint(for round: Int) -> Int {
        return getDrawingTopic(for: round).count
    }

    func isGuessCorrect(guess: String, for round: Int) -> Bool {
        //print(getDrawingTopic(for: round))
        return guess == getDrawingTopic(for: round)
    }

}
