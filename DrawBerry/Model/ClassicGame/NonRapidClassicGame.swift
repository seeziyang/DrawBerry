//
//  NonRapidClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class NonRapidClassicGame: ClassicGame {
    init(roomCode: RoomCode, players: [ClassicPlayer], currentRound: Int, topics: [String]) {
        super.init(
            from: roomCode, players: players, currentRound: currentRound,
            maxRounds: .max, topics: topics,
            roundMasterIndex: NonRapidClassicGame.calculateRoundMasterIndex(forRound: currentRound,
                                                                            players: players)
        )
    }

    override init(from room: GameRoom) {
        super.init(from: room)
    }

    override func observePlayersDrawing() {
        // users vote previous rounds drawing in non-rapid mode
        let round = currentRound - 1

        for player in players {
            observe(player: player, for: round, completionHandler: { [weak self] image in
                player.addDrawing(image: image)
                self?.delegate?.drawingsDidUpdate()
            })
        }
    }

    override func hasAllPlayersDrawnForCurrentRound() -> Bool {
        players.allSatisfy { $0.hasDrawing(ofRound: 1) }
    }

    override func userVoteFor(player: ClassicPlayer) {
        // users vote for previous rounds drawing in non-rapid mode
        let round = currentRound - 1

        user.voteFor(player: player)

        player.points += ClassicGame.votingPoints

        if player === getPrevRoundMaster() {
            user.points += ClassicGame.pointsForCorrectPick
            voteFor(player: player, for: currentRound,
                    updatedPlayerPoints: player.points, updatedUserPoints: user.points)
        } else {
            voteFor(player: player, for: round, updatedPlayerPoints: player.points)
        }
    }

    static func calculateRoundMasterIndex(forRound round: Int, players: [ClassicPlayer]) -> Int {
        let firstRoundMasterIndex = players.sorted().firstIndex(where: { $0.isRoomMaster }) ?? 0
        return (firstRoundMasterIndex + round - 1) % players.count
    }

    private func getPrevRoundMaster() -> ClassicPlayer {
        // circular array previous index
        let prevRoundMasterIndex = roundMasterIndex == 0 ? players.count - 1 : roundMasterIndex - 1
        return players[prevRoundMasterIndex]
    }
}
