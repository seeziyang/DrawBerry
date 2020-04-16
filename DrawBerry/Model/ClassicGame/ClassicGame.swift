//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGame: MultiplayerNetworkGame {
    var players: [ClassicPlayer]
    var user: ClassicPlayer
    var currentRound: Int
    let maxRounds: Int
    private var roundMasterIndex: Int
    // round master is the player who chooses the topic for the current round
    var roundMaster: ClassicPlayer {
        players[roundMasterIndex]
    }

    let gameNetwork: GameNetwork
    let roomCode: RoomCode

    static let votingPoints = 20
    static let pointsForCorrectPick = 10

    weak var delegate: ClassicGameDelegate?

    let isRapid: Bool

    init(from room: GameRoom) {
        let players = room.players.sorted().map { ClassicPlayer(from: $0) }
        self.players = players
        self.user = players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() }) ?? players[0]
        self.currentRound = 1
        self.maxRounds = ClassicGame.calculateMaxRounds(numPlayers: players.count)
        self.roundMasterIndex = players.firstIndex(where: { $0.isRoomMaster }) ?? 0

        self.gameNetwork = FirebaseGameNetworkAdapter(roomCode: room.roomCode)
        self.roomCode = room.roomCode

        self.isRapid = room.isRapid
    }

    // will refactor this out to its own subclass later so dont worry about the duplicated inits first
    init(nonRapidRoomCode roomCode: RoomCode, players: [ClassicPlayer], currentRound: Int) {
        let sortedPlayers = players.sorted()
        self.players = sortedPlayers
        self.user = sortedPlayers.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? sortedPlayers[0]
        self.currentRound = currentRound
        self.maxRounds = .max
        self.roundMasterIndex = sortedPlayers.firstIndex(where: { $0.isRoomMaster }) ?? 0

        self.gameNetwork = FirebaseGameNetworkAdapter(roomCode: roomCode)
        self.roomCode = roomCode

        self.isRapid = false
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
        // users vote previous rounds drawing in non-rapid mode
        let round = isRapid ? currentRound : currentRound - 1

        for player in players {
            if isRapid && player === user {
                continue
            }
            observe(player: player, for: round, completionHandler: { [weak self] image in
                player.addDrawing(image: image)
                self?.delegate?.drawingsDidUpdate()
            })
        }
    }

    func hasAllPlayersDrawnForCurrentRound() -> Bool {
        let round = isRapid ? currentRound : 1
        return players.allSatisfy { $0.hasDrawing(ofRound: round) }
    }

    func hasAllPlayersVotedForCurrentRound() -> Bool {
        players.allSatisfy { $0.hasVoted(inRound: currentRound) }
    }

    func userVoteFor(player: ClassicPlayer) {
        // users vote for previous rounds drawing in non-rapid mode
        let round = isRapid ? currentRound : currentRound - 1

        user.voteFor(player: player)

        player.points += ClassicGame.votingPoints

        if player === roundMaster {
            user.points += ClassicGame.pointsForCorrectPick
            voteFor(player: player, for: round, updatedPlayerPoints: user.points)
        } else {
            voteFor(player: player, for: round, updatedPlayerPoints: player.points)
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
