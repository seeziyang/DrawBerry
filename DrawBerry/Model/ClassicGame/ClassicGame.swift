//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGame: MultiplayerNetworkGame<ClassicPlayer> {
    private var topics: [String]
    private(set) var roundMasterIndex: Int
    // round master is the player who chooses the topic for the current round
    var roundMaster: ClassicPlayer {
        players[roundMasterIndex]
    }

    static let votingPoints = 20
    static let pointsForCorrectPick = 10

    static let drawingDuration: Double = 60.0
    static let votingDuration: Double = 45.0
    static let viewingDuration: Double = 7.5

    weak var delegate: ClassicGameDelegate?

    init(from room: GameRoom) {
        self.topics = []
        self.roundMasterIndex = 0
        super.init(from: room,
                   maxRounds: ClassicGame.calculateMaxRounds(numPlayers: room.players.count))
        self.roundMasterIndex = self.players.firstIndex(where: { $0.isRoomMaster }) ?? 0
    }

    init(from roomCode: RoomCode, players: [ClassicPlayer], currentRound: Int, maxRounds: Int,
         topics: [String], roundMasterIndex: Int) {
        self.topics = topics
        self.roundMasterIndex = roundMasterIndex
        super.init(from: roomCode, players: players, currentRound: currentRound, maxRounds: maxRounds)
    }

    // Calculate the maximum number of rounds for a game with a given number of players
    // Ensures that there's at least 6 rounds
    static func calculateMaxRounds(numPlayers: Int) -> Int {
        if numPlayers <= 3 {
            return numPlayers * 3
        } else if numPlayers <= 5 {
            return numPlayers * 2
        } else {
            return numPlayers
        }
    }

    // observe other player's drawing for the current round
    func observePlayersDrawing() {
        // don't need to observe user as drawing is already added to user
        for player in players where player !== user {
            observe(player: player, for: currentRound, completionHandler: { [weak self] image in
                player.addDrawing(image: image)
                self?.delegate?.drawingsDidUpdate()
            })
        }
    }

    // returns true if all players have drawn for the current round
    func hasAllPlayersDrawnForCurrentRound() -> Bool {
        players.allSatisfy { $0.hasDrawing(ofRound: currentRound) }
    }

    // returns true if all players have voted for the current round
    func hasAllPlayersVotedForCurrentRound() -> Bool {
        players.allSatisfy { $0.hasVoted(inRound: currentRound) }
    }

    // the user votes for another player
    func userVoteFor(player: ClassicPlayer) {
        user.voteFor(player: player)

        player.points += ClassicGame.votingPoints

        if player === roundMaster {
            user.points += ClassicGame.pointsForCorrectPick
            voteFor(player: player, for: currentRound,
                    updatedPlayerPoints: player.points, updatedUserPoints: user.points)
        } else {
            voteFor(player: player, for: currentRound, updatedPlayerPoints: player.points)
        }
    }

    // observe who other players voted for and update their points accordingly
    // if all players have voted for the current round, end the current round and move to the next round
    func observePlayerVotes() {
        for player in players where player !== user {
            observePlayerVote(
                player: player,
                for: currentRound,
                completionHandler: { [weak self] votedForPlayerUID in
                    guard let votedForPlayer =
                        self?.players.first(where: { $0.uid == votedForPlayerUID }) else {
                            return
                    }

                    player.voteFor(player: votedForPlayer)

                    votedForPlayer.points += ClassicGame.votingPoints
                    if votedForPlayer === self?.roundMaster {
                        player.points += ClassicGame.pointsForCorrectPick
                    }

                    self?.delegate?.votesDidUpdate()

                    if self?.hasAllPlayersVotedForCurrentRound() ?? false {
                        self?.endRound()
                    }
                }
            )
        }
    }

    // end current round
    private func endRound() {
        if isLastRound {
            endGame()
        } else {
            moveToNextRound()
        }
    }

    // move to the next round after viewingDuration, update currentRound and roundMaster
    private func moveToNextRound() {
        delegate?.showCountdownTimer(for: ClassicGame.viewingDuration)
        Timer.scheduledTimer(
            withTimeInterval: ClassicGame.viewingDuration,
            repeats: false,
            block: { [weak self] _ in
                self?.currentRound += 1
                self?.moveRoundMasterIndex()
                self?.delegate?.segueToNextRound()
            }
        )
    }

    // move to the next index in the circular array of players
    private func moveRoundMasterIndex() {
        roundMasterIndex = getNextRoundMasterIndex()
    }

    private func getNextRoundMasterIndex() -> Int {
        (roundMasterIndex + 1) % players.count
    }

    func userIsNextRoundMaster() -> Bool {
        user === players[getNextRoundMasterIndex()]
    }

    // ends the game after viewingDuration
    private func endGame() {
        delegate?.showCountdownTimer(for: ClassicGame.viewingDuration)
        Timer.scheduledTimer(
            withTimeInterval: ClassicGame.viewingDuration,
            repeats: false,
            block: { [weak self] _ in
                self?.endGame(isRoomMaster: self?.user.isRoomMaster ?? false,
                              numRounds: self?.currentRound ?? 0)
                self?.delegate?.segueToGameEnd()
            }
        )
    }

    // get the topic for the current round
    func getCurrentRoundTopic() -> String {
        let index = currentRound - 1
        return topics[index]
    }

    // set the topic for the first round
    func addFirstRoundTopic(_ topic: String) {
        setTopic(topic: topic, forRound: 1)
        topics.append(topic)
    }

    // set the next round's topic
    func addNextRoundTopic(_ topic: String) {
        setTopic(topic: topic, forRound: currentRound + 1)
        topics.append(topic)
    }

    // observe what is the topic for the first round
    func observeFirstRoundTopic(completionHandler: @escaping () -> Void) {
        observeTopic(for: 1, completionHandler: { [weak self] topic in
            self?.topics.append(topic)
            completionHandler()
        })
    }

    // observe what is the topic for the next round
    func observeNextRoundTopic() {
        observeTopic(for: currentRound + 1, completionHandler: { [weak self] topic in
            self?.topics.append(topic)
        })
    }
}

/// Extensions to network interface
extension ClassicGame {
    func voteFor(player: ClassicPlayer, for round: Int,
                 updatedPlayerPoints: Int, updatedUserPoints: Int? = nil) {
        gameNetwork.userVoteFor(playerUID: player.uid, forRound: round,
                                updatedPlayerPoints: player.points, updatedUserPoints: updatedUserPoints)
    }

    func observePlayerVote(player: ClassicPlayer, for round: Int,
                           completionHandler: @escaping (String) -> Void) {
        gameNetwork.observePlayerVote(playerUID: player.uid, forRound: round,
                                      completionHandler: completionHandler)
    }

    func setTopic(topic: String, forRound round: Int) {
        gameNetwork.setTopic(topic: topic, forRound: round)
    }

    func observeTopic(for round: Int, completionHandler: @escaping (String) -> Void) {
        gameNetwork.observeTopic(forRound: round, completionHandler: completionHandler)
    }
}
