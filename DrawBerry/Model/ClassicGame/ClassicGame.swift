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
    private var roundMasterIndex: Int
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

    init(from roomCode: RoomCode, players: [ClassicPlayer],
         currentRound: Int, maxRounds: Int, topics: [String]) {
        self.topics = topics
        self.roundMasterIndex = 0
        super.init(from: roomCode, players: players, currentRound: currentRound, maxRounds: maxRounds)
        self.roundMasterIndex = self.players.firstIndex(where: { $0.isRoomMaster }) ?? 0
    }

    static func calculateMaxRounds(numPlayers: Int) -> Int {
        if numPlayers <= 3 {
            return numPlayers * 3
        } else if numPlayers <= 5 {
            return numPlayers * 2
        } else {
            return numPlayers
        }
    }

    func observePlayersDrawing() {
        // don't need to observe user as drawing is already added to user
        for player in players where player !== user {
            observe(player: player, for: currentRound, completionHandler: { [weak self] image in
                player.addDrawing(image: image)
                self?.delegate?.drawingsDidUpdate()
            })
        }
    }

    func hasAllPlayersDrawnForCurrentRound() -> Bool {
        players.allSatisfy { $0.hasDrawing(ofRound: currentRound) }
    }

    func hasAllPlayersVotedForCurrentRound() -> Bool {
        players.allSatisfy { $0.hasVoted(inRound: currentRound) }
    }

    func userVoteFor(player: ClassicPlayer) {
        user.voteFor(player: player)

        player.points += ClassicGame.votingPoints

        if player === roundMaster {
            user.points += ClassicGame.pointsForCorrectPick
            voteFor(player: player, for: currentRound, updatedPlayerPoints: user.points)
        } else {
            voteFor(player: player, for: currentRound, updatedPlayerPoints: player.points)
        }
    }

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

    private func endRound() {
        if isLastRound {
            endGame()
        } else {
            moveToNextRound()
        }
    }

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

    private func moveRoundMasterIndex() {
        roundMasterIndex = getNextRoundMasterIndex()
    }

    private func getNextRoundMasterIndex() -> Int {
        (roundMasterIndex + 1) % players.count
    }

    func userIsNextRoundMaster() -> Bool {
        user === players[getNextRoundMasterIndex()]
    }

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

    func getCurrentRoundTopic() -> String {
        let index = currentRound - 1
        return topics[index]
    }

    func addFirstRoundTopic(_ topic: String) {
        setTopic(topic: topic, forRound: 1)
        topics.append(topic)
    }

    func addNextRoundTopic(_ topic: String) {
        setTopic(topic: topic, forRound: currentRound + 1)
        topics.append(topic)
    }

    func observeFirstRoundTopic(completionHandler: @escaping () -> Void) {
        observeTopic(for: 1, completionHandler: { [weak self] topic in
            self?.topics.append(topic)
            completionHandler()
        })
    }

    func observeNextRoundTopic() {
        observeTopic(for: currentRound + 1, completionHandler: { [weak self] topic in
            self?.topics.append(topic)
        })
    }
}

/// Extensions to network interface
extension ClassicGame {
    func voteFor(player: ClassicPlayer, for round: Int, updatedPlayerPoints: Int) {
        gameNetwork.userVoteFor(playerUID: player.uid, forRound: round,
                                updatedPlayerPoints: player.points, updatedUserPoints: nil)
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
