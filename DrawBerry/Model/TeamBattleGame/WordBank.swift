//
//  WordBank.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct WordBank {
    var words: [TopicWord]
    // TODO: Init from file

    // Default constructor
    init() {
        words = [TopicWord("apple"), TopicWord("banana"), TopicWord("cat"),
                 TopicWord("dog"), TopicWord("ear"), TopicWord("food")]
    }

    mutating func getWordList(length: Int, difficulty: WordDifficulty) -> WordList {
        var list = [TopicWord]()
        for _ in 0..<length {
            list.append(popRandomWord(difficulty: difficulty) ?? getWordWhenEmptyWordBank())
        }
        return WordList(words: list)
    }

    mutating func popRandomWord(difficulty: WordDifficulty) -> TopicWord? {
        let filteredWords = words.filter { $0.difficulty == difficulty }

        return popRandomWord(from: filteredWords)
    }

    mutating func reloadWordBank() {
        words = [TopicWord("apple"), TopicWord("banana"), TopicWord("cat"),
                 TopicWord("dog"), TopicWord("ear"), TopicWord("food")]
    }

    private mutating func popRandomWord(from words: [TopicWord]) -> TopicWord? {
        let poppedWord = getRandomWord(from: words)
        self.words = words.filter { $0.value != poppedWord?.value }
        return poppedWord
    }

    private func getRandomWord(from words: [TopicWord]) -> TopicWord? {
        return words.randomElement()
    }

    func getWordWhenEmptyWordBank() -> TopicWord {
        return TopicWord("dog")
    }

}
