//
//  TeamBattleGame.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleGame: NetworkGame {
    let gameNetwork: GameNetwork
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

    var currentRound: Int

    convenience init(from room: GameRoom) {
        self.init(from: room, gameNetwork: FirebaseGameNetworkAdapter(roomCode: room.roomCode))!
    }

    init?(from room: GameRoom, gameNetwork: GameNetwork) {
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

        self.gameNetwork = FirebaseGameNetworkAdapter(roomCode: room.roomCode)

        self.userIndex = players.firstIndex(where: { $0.uid == gameNetwork.getLoggedInUserID() }) ?? 0

        self.currentRound = 1

        self.roomCode = room.roomCode
    }

    func incrementRound() {
        currentRound += 1
    }

    /// Uploads drawer's drawing to db
    func addTeamDrawing(image: UIImage) {
        upload(image: image, for: currentRound)
    }

    func observeTeamDrawing() {
        guard let id = userTeam?.teamID else {
            return
        }

        for round in 1...maxRounds {
            observe(uid: id, for: round, completionHandler: { [weak self] image in
                self?.delegate?.updateDrawing(image, for: round)
            })
        }
    }
}

/// Extensions to network interface
extension TeamBattleGame {
    func addTeamResult(result: TeamBattleTeamResult) {
        gameNetwork.uploadTeamResult(result: result)
    }

    func observeAllTeamResult() {
        for team in teams {
            let id = team.teamID
            gameNetwork.observeAndDownloadTeamResult(
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

    func endGame() {
        endGame(isRoomMaster: user.isRoomMaster, numRounds: maxRounds)
    }
}
