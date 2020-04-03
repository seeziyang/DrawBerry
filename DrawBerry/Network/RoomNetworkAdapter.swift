//
//  NetworkRoomHelper.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class RoomNetworkAdapter {

    let db: DatabaseReference
    private var observingRoomCode: RoomCode?

    init() {
        self.db = Database.database().reference()
    }

    deinit {
        if let observingRoomCode = observingRoomCode {
            let dbPathRef = db.child("activeRooms")
                .child(observingRoomCode.type.rawValue)
                .child(observingRoomCode.value)
            dbPathRef.child("player").removeAllObservers()
            dbPathRef.child("hasStarted").removeAllObservers()
            dbPathRef.child("isRapid").removeAllObservers()
        }
    }

    func createRoom(roomCode: RoomCode) {
        guard let userID = NetworkHelper.getLoggedInUserID(),
            let username = NetworkHelper.getLoggedInUserName() else {
                return
        }

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .setValue([
                "isRapid": true,
                "players": [
                    userID: [
                        "username": username,
                        "isRoomMaster": true
                    ]
                ]
            ])
    }

    func checkRoomExists(roomCode: RoomCode, completionHandler: @escaping (Bool) -> Void) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .observeSingleEvent(of: .value, with: { snapshot in
                completionHandler(snapshot.exists())
            })
    }

    func checkRoomEnterable(roomCode: RoomCode, completionHandler: @escaping (GameRoomStatus) -> Void) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let roomValue = snapshot.value as? [String: AnyObject] else {
                    completionHandler(.doesNotExist) // room does not exists
                    return
                }

                if roomValue["hasStarted"] as? Bool ?? false {
                    completionHandler(.started)
                    return
                }

                guard let numPlayers = roomValue["players"]?.count else {
                    // Databse error, should not happen
                    completionHandler(.doesNotExist)
                    return
                }

                let isNotFull = numPlayers < GameRoom.maxPlayers
                completionHandler(isNotFull ? .enterable : .full)
            })
    }

    func joinRoom(roomCode: RoomCode) {
        guard let userID = NetworkHelper.getLoggedInUserID(),
            let username = NetworkHelper.getLoggedInUserName() else {
                return
        }

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .setValue(["username": username,
                       "isRoomMaster": false])
    }

    func leaveRoom(roomCode: RoomCode, isRoomMaster: Bool) {
        guard let userID = NetworkHelper.getLoggedInUserID() else {
            return
        }

        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)

        if isRoomMaster {
            dbPathRef.removeValue(completionBlock: { [weak self] _, _ in
                self?.handoverRoomMaster(roomCode: roomCode)
            })
        } else {
            dbPathRef.removeValue()
        }

    }

    private func handoverRoomMaster(roomCode: RoomCode) {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")

        dbPathRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let players = snapshot.value as? [String: Any] else {
                return
            }

            guard let firstOtherPlayerUID = players.first?.key else {
                return
            }

            dbPathRef.child(firstOtherPlayerUID)
                .child("isRoomMaster")
                .setValue(true)
        })
    }

    func deleteRoom(roomCode: RoomCode) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .removeValue()
    }

    func setIsRapid(roomCode: RoomCode, isRapid: Bool) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("isRapid")
            .setValue(isRapid)
    }

    func startGame(roomCode: RoomCode, isRapid: Bool) {
        let dbRoomPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)

        dbRoomPathRef
            .child("hasStarted")
            .setValue(true)
        dbRoomPathRef
            .child("currRound")
            .setValue(1)

        // add persisting non-rapid games under each player's user info in db
        if !isRapid {
            dbRoomPathRef.child("players")
                .observeSingleEvent(of: .value, with: { snapshot in
                    guard let players = snapshot.value as? [String: Any] else {
                        return
                    }

                    let playersUIDs = players.keys
                    playersUIDs.forEach { [weak self] playerUID in
                        self?.db.child("users")
                            .child(playerUID)
                            .child("activeNonRapidGames")
                            .child(roomCode.value)
                            .setValue(true)
                    }
                })
        }
    }

    func observeRoomPlayers(roomCode: RoomCode, listener: @escaping ([RoomPlayer]) -> Void) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .observe(.value, with: { snapshot in
                guard let playersValue = snapshot.value as? [String: [String: Any]] else {
                    return
                }

                let players = playersValue.map { playerUID, properties in
                    RoomPlayer(name: properties["username"] as? String ?? "Player",
                               uid: playerUID,
                               isRoomMaster: properties["isRoomMaster"] as? Bool ?? false)
                }

                listener(players)
            })
    }

    func observeGameStart(roomCode: RoomCode, listener: @escaping (Bool) -> Void) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("hasStarted")
            .observe(.value, with: { snapshot in
                guard let hasStartedValue = snapshot.value as? Bool else {
                    return
                }

                listener(hasStartedValue)
            })
    }

    func observeIsRapidToggle(roomCode: RoomCode, listener: @escaping (Bool) -> Void) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("isRapid")
            .observe(.value, with: { snapshot in
                guard let isRapidValue = snapshot.value as? Bool else {
                    return
                }

                listener(isRapidValue)
            })
    }

    func getUsersNonRapidGameRoomCodes(completionHandler: @escaping ([RoomCode]) -> Void) {
        guard let userID = NetworkHelper.getLoggedInUserID() else {
            return
        }

        db.child("users")
            .child(userID)
            .child("activeNonRapidGames")
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let roomCodesDict = snapshot.value as? [String: Bool] else {
                    return
                }

                let roomCodes = roomCodesDict.keys.map { RoomCode(value: $0, type: .ClassicRoom) }
                completionHandler(roomCodes)
            })
    }

    func checkNonRapidGameTurn(
        roomCode: RoomCode,
        completionHandler: @escaping (ActiveRoomTurn, ClassicGame) -> Void
    ) {
        guard let userID = NetworkHelper.getLoggedInUserID() else {
            return
        }

        // TODO: FIX WRONG TURN result logic

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let roomValues = snapshot.value as? [String: Any] else {
                    return
                }

                guard let currRound = roomValues["currRound"] as? Int else {
                    return
                }

                // [playerUID: [rounds: Any]]
                guard let playersDict = roomValues["players"] as? [String: [String: Any]] else {
                    return
                }

                var players: [ClassicPlayer] = []
                playersDict.forEach { playerUID, values in
                    guard let isRoomMaster = values["isRoomMaster"] as? Bool,
                        let points = (values["points"] == nil) ? 0 : values["points"] as? Int ,
                        let name = values["username"] as? String else {
                            return
                    }

                    players.append(ClassicPlayer(name: name, uid: playerUID,
                                                 isRoomMaster: isRoomMaster, points: points))
                }

                let classicGame = ClassicGame(nonRapidRoomCode: roomCode,
                                              players: players, currentRound: currRound)

                // [playerUID: [roundNumber: [hasUploadedImage: Any]]]
                guard let playerRounds = playersDict.mapValues({ $0["rounds"] })
                    as? [String: [String: [String: Any]]] else {
                        completionHandler(.notMyTurn, classicGame)
                        return
                }

                let hasUserDrawn =
                    playerRounds[userID]?["round\(currRound)"]?["hasUploadedImage"] as? Bool ?? false

                if !hasUserDrawn {
                    completionHandler(.drawingTurn, classicGame)
                    return
                }

                let hasAllPlayersDrawn = playerRounds.values
                    .allSatisfy { $0["round\(currRound)"]?["hasUploadedImage"] as? Bool ?? false }

                if hasAllPlayersDrawn {
                    completionHandler(.votingTurn, classicGame)
                } else {
                    completionHandler(.notMyTurn, classicGame)
                }
            })
    }
}
