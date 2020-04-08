//
//  TeamBattleGame.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleGame: Game {
    let networkAdapter: GameNetworkAdapter
    let roomCode: RoomCode
    let maxRounds = 3
    var players: [TeamBattlePlayer]
    var teams = [TeamBattlePair]()
    var delegate: TeamBattleGameDelegate?

    let userIndex: Int
    var user: TeamBattlePlayer {
        players[userIndex]
    }

    var userTeam: TeamBattlePair? {
        for team in teams where team.teamPlayers.contains(user) {
            return team
        }
        return nil
    }


    private(set) var currentRound: Int

    convenience init(from room: GameRoom) {
        self.init(from: room, networkAdapter: GameNetworkAdapter(roomCode: room.roomCode))
    }

    init(from room: GameRoom, networkAdapter: GameNetworkAdapter) {
        self.roomCode = room.roomCode
        self.networkAdapter = networkAdapter

        let players = room.players.map { TeamBattlePlayer(from: $0) }
        self.players = players

        let drawerIndices = Array(stride(from: 0, to: players.count, by: 2))
        print(drawerIndices)
        for index in drawerIndices {
            let drawer = TeamBattleDrawer(from: room.players[index])
            let guesser = TeamBattleGuesser(from: room.players[index + 1])
            let team = TeamBattlePair(drawer: drawer, guesser: guesser)
            teams.append(team)
        }

        self.userIndex = self.players.firstIndex(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
        ?? 0

        self.currentRound = 1
    }

    func addUsersDrawing(image: UIImage) {
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observeTeamDrawing() {
        guard let id = userTeam?.teamID else {
            return
        }
        let round = currentRound

        networkAdapter.waitAndDownloadPlayerDrawing(
            playerUID: id, forRound: round,
            completionHandler: { [weak self] image in
                //user.draw
                self?.delegate?.updateDrawing(image)
            }
        )

    }

}
