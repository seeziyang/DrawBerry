//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGame: MultiplayerNetworkGame {
    static let votingPoints = 20
    static let pointsForCorrectPick = 10

    weak var delegate: ClassicGameDelegate?
    let isRapid: Bool

    private var roundMasterIndex: Int
    // round master is the player who chooses the topic for the current round
    var roundMaster: MultiplayerPlayer {
        players[roundMasterIndex]
    }
    var classicPlayers: [ClassicPlayer] {
        players.compactMap { $0 as? ClassicPlayer }
    }

    init(from room: GameRoom) {
        self.isRapid = room.isRapid
        self.roundMasterIndex = room.players.sorted().firstIndex(where: { $0.isRoomMaster }) ?? 0
        super.init(from: room, maxRounds: ClassicGame.calculateMaxRounds(numPlayers: room.players.count))
    }

    init?(from room: GameRoom, networkAdapter: GameNetworkAdapter) {
        self.isRapid = room.isRapid
        self.roundMasterIndex = room.players.sorted().firstIndex(where: { $0.isRoomMaster }) ?? 0
        super.init(
            from: room,
            maxRounds: ClassicGame.calculateMaxRounds(numPlayers: room.players.count),
            networkAdapter: networkAdapter
        )
    }

    init(nonRapidRoomCode roomCode: RoomCode, players: [ClassicPlayer], currentRound: Int) {
        let sortedPlayers = players.sorted()
        self.isRapid = false
        self.roundMasterIndex = players.sorted().firstIndex(where: { $0.isRoomMaster }) ?? 0
        super.init(from: roomCode, players: sortedPlayers, currentRound: currentRound)
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
        return classicPlayers.allSatisfy { $0.hasDrawing(ofRound: round) }
    }

    func hasAllPlayersVotedForCurrentRound() -> Bool {
        players.compactMap { $0 as? ClassicPlayer }
            .allSatisfy { $0.hasVoted(inRound: currentRound) }
    }

    func userVoteFor(player: ClassicPlayer) {
        // users vote for previous rounds drawing in non-rapid mode
        let round = isRapid ? currentRound : currentRound - 1
        guard let classicUser = user as? ClassicPlayer else {
            return
        }

        classicUser.voteFor(player: player)

        player.points += ClassicGame.votingPoints

        if player === roundMaster {
            classicUser.points += ClassicGame.pointsForCorrectPick
            voteFor(player: player, for: round, updatedPlayerPoints: classicUser.points)
        } else {
            voteFor(player: player, for: round, updatedPlayerPoints: player.points)
        }
    }

    func observePlayerVotes() {
        for player in players.compactMap({ $0 as? ClassicPlayer }) where player !== user {
            observePlayerVote(
                player: player, for: currentRound, completionHandler: { [weak self] votedForPlayerUID in
                    guard let votedForPlayer =
                        self?.classicPlayers.first(where: { $0.uid == votedForPlayerUID }) else {
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
