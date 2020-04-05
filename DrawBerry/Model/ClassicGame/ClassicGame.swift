//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGame: Game {
    static let votingPoints = 20
    static let pointsForCorrectPick = 10

    weak var delegate: ClassicGameDelegate?
    let networkAdapter: GameNetworkAdapter
    let roomCode: RoomCode
    let isRapid: Bool

    let players: [ClassicPlayer]
    let user: ClassicPlayer // players array contains user too

    private let maxRounds: Int
    private(set) var currentRound: Int
    private var roundMasterIndex: Int
    // round master is the player who chooses the topic for the current round
    var roundMaster: ClassicPlayer {
        players[roundMasterIndex]
    }
    var isLastRound: Bool {
        currentRound == maxRounds
    }

    convenience init(from room: GameRoom) {
        self.init(from: room, networkAdapter: GameNetworkAdapter(roomCode: room.roomCode))
    }

    init(from room: GameRoom, networkAdapter: GameNetworkAdapter) {
        self.roomCode = room.roomCode
        self.isRapid = room.isRapid
        self.networkAdapter = networkAdapter
        let players = room.players.map { ClassicPlayer(from: $0) }.sorted()
        self.players = players
        self.user = players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? players[0]
        self.maxRounds = ClassicGame.calculateMaxRounds(numPlayers: players.count)
        self.currentRound = 1
        self.roundMasterIndex = self.players.firstIndex(where: { $0.isRoomMaster }) ?? 0
    }

    init(nonRapidRoomCode roomCode: RoomCode, players: [ClassicPlayer], currentRound: Int) {
        let sortedPlayers = players.sorted()
        self.roomCode = roomCode
        self.isRapid = false
        self.networkAdapter = GameNetworkAdapter(roomCode: roomCode)
        self.players = sortedPlayers
        self.user = sortedPlayers.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? sortedPlayers[0]
        self.maxRounds = .max // non rapid games are currently infinitely long
        self.currentRound = currentRound
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

    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observePlayersDrawing() {
        // users vote previous rounds drawing in non-rapid mode
        let round = isRapid ? currentRound : currentRound - 1

        for player in players {
            if isRapid && player === user {
                continue
            }

            networkAdapter.waitAndDownloadPlayerDrawing(
                playerUID: player.uid, forRound: round,
                completionHandler: { [weak self] image in
                    player.addDrawing(image: image)

                    self?.delegate?.drawingsDidUpdate()
                }
            )
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
            networkAdapter.userVoteFor(playerUID: player.uid, forRound: round,
                                       updatedPlayerPoints: player.points,
                                       updatedUserPoints: user.points)
        } else {
            networkAdapter.userVoteFor(playerUID: player.uid, forRound: round,
                                       updatedPlayerPoints: player.points)
        }
    }

    func observePlayerVotes() {
        for player in players where player !== user {
            networkAdapter.observePlayerVote(
                playerUID: player.uid, forRound: currentRound,
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
            self?.networkAdapter.endGame(isRoomMaster: self?.user.isRoomMaster ?? false,
                                         numRounds: self?.currentRound ?? 0)

            self?.delegate?.segueToGameEnd()
        })
    }
}
