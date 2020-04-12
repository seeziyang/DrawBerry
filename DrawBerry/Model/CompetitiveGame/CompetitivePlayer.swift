//
//  Player.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitivePlayer: Player, Equatable, Hashable {
    init(name: String, canvasDrawing: CompetitiveCanvas) {
        self.name = name
        self.canvasDrawing = canvasDrawing
    }

    var name: String
    var canvasDrawing: CompetitiveCanvas
    var extraStrokes = 0

    var score = 0

    static var NUMBER_OF_VOTES_TO_GIVE = 2
    var votesLeft = CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE
    var votesGiven = 0
    var hasVotedFor = Set<CompetitivePlayer>()

    var isDoneVoting: Bool {
        votesLeft <= 0
    }

    func resetVotes() {
        votesLeft = CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE
        votesGiven = 0
        hasVotedFor.removeAll()
    }

    static func == (lhs: CompetitivePlayer, rhs: CompetitivePlayer) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    /// Removes a specified decorator from the player's canvas.
    /// If not found, searches until `nil`.
    func removeDecorator(decoratorToRemove decorator: CompetitiveCanvas) {
        if canvasDrawing == decorator {
            guard let nextCanvas = canvasDrawing.decoratedCanvas else {
                return
            }
            canvasDrawing = nextCanvas
        }
        removeDecoratorRecursive(decoratorToRemove: decorator, prevCanvas: canvasDrawing)
    }

    func removeDecoratorRecursive(decoratorToRemove decorator: CompetitiveCanvas, prevCanvas: CompetitiveCanvas) {
        guard let nextNode = prevCanvas.decoratedCanvas else {
            return
        }

        if nextNode == decorator {
            prevCanvas.decoratedCanvas = nextNode.decoratedCanvas
            return
        }
        removeDecoratorRecursive(decoratorToRemove: decorator, prevCanvas: nextNode)
    }
}
