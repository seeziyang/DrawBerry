//
//  TopicWord.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct TopicWord: Word, Hashable {
    var value: String
    var difficulty: WordDifficulty

    init(_ value: String, difficulty: WordDifficulty) {
        self.value = value
        self.difficulty = difficulty
    }

    init(_ value: String) {
        self.value = value
        self.difficulty = .Easy
    }

    static func == (lhs: TopicWord, rhs: TopicWord) -> Bool {
        lhs.value == rhs.value
        && lhs.difficulty == rhs.difficulty
    }
}
