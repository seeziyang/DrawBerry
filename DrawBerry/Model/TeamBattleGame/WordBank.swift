//
//  WordBank.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct WordBank {
    var words: [Word]
    // TODO: Init from file

    // Default constructor
    init() {
        words = [TopicWord("apple"), TopicWord("banana"), TopicWord("cat")]
    }

    mutating func getWordList(length: Int, difficulty: WordDifficulty) -> WordList {
        var list = [Word]()
        for _ in 0..<length {
            list.append(popRandomWord(difficulty: difficulty) ?? getWordWhenEmptyWordBank())
        }
        return WordList(words: list)
    }

    mutating func popRandomWord(difficulty: WordDifficulty) -> Word? {
        let filteredWords = words.filter { $0.difficulty == difficulty }

        return popRandomWord(from: filteredWords)
    }

    mutating func reloadWordBank() {
        words = [TopicWord("apple"), TopicWord("banana"), TopicWord("cat")]
    }

    private mutating func popRandomWord(from words: [Word]) -> Word? {
        let poppedWord = getRandomWord(from: words)
        self.words = words.filter { $0.value != poppedWord?.value }
        return poppedWord
    }

    private func getRandomWord(from words: [Word]) -> Word? {
        return words.randomElement()
    }

    func getWordWhenEmptyWordBank() -> Word {
        return TopicWord("dog")
    }

}
