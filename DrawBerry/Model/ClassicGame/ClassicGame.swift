//
//  ClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGame {
    static let maxRounds = 5

    static let votingPoints = 20
    static let pointsForCorrectPick = 10

    weak var delegate: ClassicGameDelegate?
    let networkAdapter: GameNetworkAdapter
    let roomCode: RoomCode

    let players: [ClassicPlayer]
    let user: ClassicPlayer // players array contains user too

    private(set) var currentRound: Int
    private var roundMasterIndex: Int
    // round master is the player who chooses the topic for the current round
    var roundMaster: ClassicPlayer {
        players[roundMasterIndex]
    }
    var isLastRound: Bool {
        currentRound == ClassicGame.maxRounds
    }

    convenience init(from room: GameRoom) {
        self.init(from: room, networkAdapter: GameNetworkAdapter(roomCode: room.roomCode))
    }

    init(from room: GameRoom, networkAdapter: GameNetworkAdapter) {
        self.roomCode = room.roomCode
        self.networkAdapter = networkAdapter
        let players = room.players.map { ClassicPlayer(from: $0) }
        self.players = players
        self.user = players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? players[0]
        self.currentRound = 1
        self.roundMasterIndex = self.players.firstIndex(where: { $0.isRoomMaster }) ?? 0
    }

    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observePlayersDrawing() {
        for player in players where player !== user {
            networkAdapter.waitAndDownloadPlayerDrawing(
                playerUID: player.uid, forRound: currentRound,
                completionHandler: { [weak self] image in
                    player.addDrawing(image: image)

                    self?.delegate?.drawingsDidUpdate()
                }
            )
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
            networkAdapter.userVoteFor(playerUID: player.uid, forRound: currentRound,
                                       updatedPlayerPoints: player.points,
                                       updatedUserPoints: user.points)
        } else {
            networkAdapter.userVoteFor(playerUID: player.uid, forRound: currentRound,
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

                    if self?.hasAllPlayersDrawnForCurrentRound() ?? false {
                        self?.moveToNextRound()
                    }
                }
            )
        }
    }

    private func moveToNextRound() {
        Timer.scheduledTimer(withTimeInterval: 10.00, repeats: false, block: { [weak self] _ in
            self?.currentRound += 1
            self?.moveRoundMasterIndex()

            self?.delegate?.segueToNextRound()
        })
    }

    private func moveRoundMasterIndex() {
        roundMasterIndex = (roundMasterIndex + 1) % players.count
    }
}
