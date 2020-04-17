//
//  WordList.swift
//  DrawBerry
//
//  Created by Calvin Chen on 17/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct WordList {
    let words: [Word]
    private var index = 0

    init(words: [Word]) {
        self.words = words
    }

    init(databaseDescription: String) {
        let substrings = databaseDescription.split(separator: "/").map { String($0) }
        let words = substrings.map { TopicWord($0) }
        self.init(words: words)
    }

    /// Gets the next word in the list
    /// Wraps around if list ends
    mutating func getNextWord() -> Word {
        let nextWord = words[index]
        index = (index + 1) % words.count

        return nextWord
    }

    func getWord(at index: Int) -> Word? {
        return words[index]
    }

    func getDatabaseDescription() -> String {
        var description = ""
        let separator = "/"
        for i in 0..<words.count {
            if i != words.count - 1 {
                description += (words[i].value + separator)
            } else {
                description += words[i].value
            }
        }

        return description
    }


}
