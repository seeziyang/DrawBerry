//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGame: MultiplayerNetworkGame<ClassicPlayer> {
    private var roundMasterIndex: Int
    // round master is the player who chooses the topic for the current round
    var roundMaster: ClassicPlayer {
        players[roundMasterIndex]
    }

    static let votingPoints = 20
    static let pointsForCorrectPick = 10

    weak var delegate: ClassicGameDelegate?

    init(from room: GameRoom) {
        self.roundMasterIndex = 0
        super.init(from: room,
                   maxRounds: ClassicGame.calculateMaxRounds(numPlayers: room.players.count))
        self.roundMasterIndex = self.players.firstIndex(where: { $0.isRoomMaster }) ?? 0
    }

    override init(from roomCode: RoomCode, players: [ClassicPlayer],
                  currentRound: Int, maxRounds: Int) {
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
        Timer.scheduledTimer(withTimeInterval: 7.5, repeats: false, block: { [weak self] _ in
            self?.currentRound += 1
            self?.moveRoundMasterIndex()
            self?.delegate?.segueToNextRound()
        })
    }

    private func moveRoundMasterIndex() {
        roundMasterIndex = (roundMasterIndex + 1) % players.count
    }

    private func endGame() {
        Timer.scheduledTimer(withTimeInterval: 7.5, repeats: false, block: { [weak self] _ in
            self?.endGame(isRoomMaster: self?.user.isRoomMaster ?? false, numRounds: self?.currentRound ?? 0)
            self?.delegate?.segueToGameEnd()
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
}
