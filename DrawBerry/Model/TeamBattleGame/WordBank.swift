//
//  WordBank.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Foundation

struct WordBank {
    var words: [Word]
    // TODO: Init from file

    // Default constructor
    init() {
        words = [TopicWord("apple"), TopicWord("banana"), TopicWord("cat")]
    }

    func getRandomWord(difficulty: WordDifficulty) -> Word? {
        let filteredWords = words.filter { $0.difficulty == difficulty }

        return getRandomWord(from: filteredWords)
    }

    private mutating func popRandomWord(from words: [Word]) -> Word? {
        let poppedWord = getRandomWord(from: words)
        self.words = words.filter { $0.value == poppedWord?.value }
        return poppedWord
    }

    private func getRandomWord(from words: [Word]) -> Word? {
        return words.randomElement()
    }

    func getWordWhenEmptyWordBank() -> Word {
        return TopicWord("dog")
    }

    mutating func reloadWordBank() {
        words = [TopicWord("apple"), TopicWord("banana"), TopicWord("cat")]
    }
}
