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

    /// Resets this player's number of votes and set of votes given.
    func resetVotes() {
        votesLeft = CompetitivePlayer.NUMBER_OF_VOTES_TO_GIVE
        votesGiven = 0
        hasVotedFor.removeAll()
    }

    func resetStrokes() {
        extraStrokes = 0
    }

    /// Votes for another player `votedPlayer`.
    /// Returns a `String` representing the result of the vote.
    @discardableResult
    func voteFor(player votedPlayer: CompetitivePlayer) -> String {
        if votesLeft <= 0 {
            return Message.competitiveVotingUsedAllVotes
        } else if self == votedPlayer {
            return Message.competitiveVotingCannotSelfVote
        } else if hasVotedFor.contains(votedPlayer) {
            return Message.competitiveVotingAlreadyVoted
        }

        let result = "You gave \(votesLeft) vote(s) to \(votedPlayer.name)"
        votedPlayer.votesGiven += votesLeft
        hasVotedFor.insert(votedPlayer)
        votesLeft -= 1
        return result
    }

    static func == (lhs: CompetitivePlayer, rhs: CompetitivePlayer) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    /// Attemps to remove a specified decorator from the player's canvas.
    /// If not found, recursively searches until `nil`.
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
        guard let nextCanvas = prevCanvas.decoratedCanvas else {
            return
        }

        if nextCanvas == decorator {
            prevCanvas.decoratedCanvas = nextCanvas.decoratedCanvas
            return
        }
        removeDecoratorRecursive(decoratorToRemove: decorator, prevCanvas: nextCanvas)
    }
}
