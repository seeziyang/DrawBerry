//
//  TeamBattleGame.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleGame: NetworkGame {
<<<<<<< HEAD
    static let maxRounds = 3
=======
    let gameNetwork: GameNetwork
    let roomCode: RoomCode

    let maxRounds = 3
>>>>>>> origin/master
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

        self.userIndex = players.firstIndex(where: { $0.uid == NetworkHelper.getLoggedInUserID() }) ?? 0

        self.currentRound = 1

        self.roomCode = room.roomCode
        self.gameNetwork = FirebaseGameNetworkAdapter(roomCode: room.roomCode)
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

        for round in 1...TeamBattleGame.maxRounds {
            observe(uid: id, for: round, completionHandler: { [weak self] image in
                self?.delegate?.updateDrawing(image, for: round)
            })
        }
    }
}

/// Extensions to network interface
extension TeamBattleGame {
    func uploadTeamWordList() {
        guard let drawer = userTeam?.drawer else {
            return
        }
        let wordList = drawer.wordList
        let networkKey = "TeamWordList"
        gameNetwork.uploadKeyValuePair(key: networkKey,
                                       playerUID: drawer.uid, value: wordList.getDatabaseDescription())
    }

    func downloadTeamWordList() {
        guard let drawer = userTeam?.drawer else {
            return
        }
        let networkKey = "TeamWordList"
        gameNetwork.observeValue(key: networkKey,
                                 playerUID: drawer.uid, completionHandler: { [weak self] databaseDescription in
            guard let wordList = WordList(databaseDescription:
                databaseDescription) else {
                return
            }

            self?.userTeam?.updateWordList(wordList)
        })
    }

    func addTeamResult(result: TeamBattleTeamResult) {
        let networkKey = "TeamResult"
        guard let id = userTeam?.drawer.uid else {
            return
        }
        gameNetwork.uploadKeyValuePair(key: networkKey, playerUID: id, value: result.getDatabaseStorageDescription())
    }

    func observeAllTeamResult() {
        let networkKey = "TeamResult"
        for team in teams {
            let id = team.teamID
            gameNetwork.observeValue(
                key: networkKey, playerUID: id,
                completionHandler: { [weak self] databaseDescription in
                    guard let result = TeamBattleTeamResult(databaseDescription: databaseDescription) else {
                        return
                    }
                    self?.gameResult.updateTeamResult(result)
                    team.updateResult(result)
                    self?.resultDelegate?.updateResults()
                }
            )
        }
    }

    func endGame() {
        endGame(isRoomMaster: user.isRoomMaster, numRounds: TeamBattleGame.maxRounds)
    }
}
