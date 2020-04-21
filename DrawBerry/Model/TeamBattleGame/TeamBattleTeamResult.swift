//
//  TeamBattleTeamResult.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleTeamResult: Hashable, Comparable {

    let resultID: String
    let scoreForCorrectGuess = 100
    let scoreForIncorrectGuess = -10

    private var correctGuess = 0
    private var incorrectGuess = 0

    init(resultID: String) {
        self.resultID = resultID
    }

    convenience init?(databaseDescription: String) {
        let substrings = databaseDescription.split(separator: "/").map { String($0) }
        guard substrings.count == 3 else {
            return nil
        }
        guard let correctGuess = Int(substrings[1]),
            let incorrectGuess = Int(substrings[2]) else {
                return nil
        }
        let id = substrings[0]
        self.init(resultID: id, correctGuess: correctGuess, incorrectGuess: incorrectGuess)
    }

    init(resultID: String, correctGuess: Int, incorrectGuess: Int) {
        self.resultID = resultID
        self.correctGuess = correctGuess
        self.incorrectGuess = incorrectGuess
    }

    func addCorrectGuess() {
        correctGuess += 1
    }

    func addIncorrectGuess() {
        incorrectGuess += 1
    }

    func calculateScore() -> Int {
        return correctGuess * scoreForCorrectGuess
            + incorrectGuess * scoreForIncorrectGuess
    }

    func getDatabaseStorageDescription() -> String {
        return "\(resultID)/\(correctGuess)/\(incorrectGuess)"
    }

    func getDisplayDescription() -> String {
        return "Team Result: \n" +
        " Correct guesses: \(correctGuess)\n" +
            "Incorrect guesses: \(incorrectGuess)\n"
        + "Score: \(calculateScore())\n"
    }

    static func == (lhs: TeamBattleTeamResult, rhs: TeamBattleTeamResult) -> Bool {
        lhs.resultID == rhs.resultID
            && lhs.correctGuess == rhs.correctGuess
            && lhs.incorrectGuess == rhs.incorrectGuess
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(resultID)
    }

    static func < (lhs: TeamBattleTeamResult, rhs: TeamBattleTeamResult) -> Bool {
        lhs.calculateScore() < rhs.calculateScore()
    }

}
