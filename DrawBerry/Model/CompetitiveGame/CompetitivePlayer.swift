//
//  Player.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitivePlayer: Player, CustomStringConvertible, Equatable, Hashable {
    init(name: String, canvasDrawing: Canvas) {
        self.name = name
        self.canvasDrawing = canvasDrawing
    }

    var name: String
    var canvasDrawing: Canvas
    var canvasProxy: Canvas? {
        isInvulnerable ? nil : canvasDrawing
    }

    var isInvulnerable = false
    var extraStrokes = 0

    var score = 0

    static var NUMBER_OF_VOTES_TO_GIVE = 2
    var votesLeft = CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE
    var votesGiven = 0
    var hasVotedFor = Set<CompetitivePlayer>()

    var isDoneVoting: Bool {
        votesLeft <= 0
    }

    var description: String {
        "(\(name))"
    }

    static func == (lhs: CompetitivePlayer, rhs: CompetitivePlayer) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    func resetVotes() {
        votesLeft = CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE
        votesGiven = 0
        hasVotedFor.removeAll()
    }
}
