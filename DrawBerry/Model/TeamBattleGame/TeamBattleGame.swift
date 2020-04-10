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
    var players = [TeamBattlePlayer]()
    var teams = [TeamBattlePair]()
    var gameResult: TeamBattleGameResult
    weak var delegate: TeamBattleGameViewDelegate?
    weak var resultDelegate: TeamBattleResultDelegate?

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

//        let players = room.players.map { TeamBattlePlayer(from: $0) }
//        self.players = players

        // Even indices players draws
        let drawerIndices = Array(stride(from: 0, to: room.players.count, by: 2))

        for index in drawerIndices {
            let drawer = TeamBattleDrawer(from: room.players[index])
            let guesser = TeamBattleGuesser(from: room.players[index + 1])
            let team = TeamBattlePair(drawer: drawer, guesser: guesser)
            teams.append(team)
            players.append(contentsOf: [drawer, guesser])
        }
        self.gameResult = TeamBattleGameResult(numberOfTeams: teams.count)

        self.userIndex = self.players.firstIndex(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
        ?? 0

        self.currentRound = 1
    }

    func incrementRound() {
        currentRound += 1
    }

    /// Uploads drawer's drawing to db
    func addTeamDrawing(image: UIImage) {
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func observeTeamDrawing() {
        guard let id = userTeam?.teamID else {
            return
        }

        for round in 1...maxRounds {
            networkAdapter.waitAndDownloadPlayerDrawing(
                playerUID: id, forRound: round,
                completionHandler: { [weak self] image in
                    self?.delegate?.updateDrawing(image, for: round)
                }
            )
        }
    }

    func addTeamResult(result: TeamBattleTeamResult) {
        networkAdapter.uploadTeamResult(result: result)
    }

    func observeAllTeamResult() {
        for team in teams {
            let id = team.teamID
            networkAdapter.waitAndDownloadTeamResult(
                playerUID: id,
                completionHandler: { [weak self] result in
                    // TODO: maybe use delegate
                    self?.gameResult.updateTeamResult(result)
                    team.updateResult(result)
                    self?.resultDelegate?.updateResults()
                }
            )
        }
    }
}
