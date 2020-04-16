//
//  NonRapidClassicGame.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class NonRapidClassicGame: ClassicGame {
    init(roomCode: RoomCode, players: [ClassicPlayer], currentRound: Int) {
        let sortedPlayers = players.sorted()
        super.init(
            players: sortedPlayers,
            user: sortedPlayers.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
                ?? sortedPlayers[0],
            currentRound: currentRound,
            maxRounds: .max,
            roundMasterIndex: sortedPlayers.firstIndex(where: { $0.isRoomMaster }) ?? 0,
            gameNetwork: FirebaseGameNetworkAdapter(roomCode: roomCode),
            roomCode: roomCode
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

        if player === roundMaster {
            user.points += ClassicGame.pointsForCorrectPick
            voteFor(player: player, for: round, updatedPlayerPoints: user.points)
        } else {
            voteFor(player: player, for: round, updatedPlayerPoints: player.points)
        }
    }
}
