//
//  EnterRoomNetworkAdapter.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class FirebaseRoomEnteringNetworkAdapter: RoomEnteringNetwork, FirebaseNetworkAdapter {
    let db: DatabaseReference
    private var observingRoomCodes: Set<RoomCode>

    init() {
        self.db = Database.database().reference()
        self.observingRoomCodes = []
    }

    deinit {
        for roomCode in observingRoomCodes {
            db.child("activeRooms")
                .child(roomCode.type.rawValue)
                .child(roomCode.value)
                .removeAllObservers()
        }
    }

    // Create room with roomCode in db
    func createRoom(roomCode: RoomCode) -> Bool {
        if FirebaseInvalidStrings.isInvalid(name: roomCode.value) {
            return false
        }
        guard let userID = getLoggedInUserID(), let username = getLoggedInUserName() else {
            return false
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
        return true
    }

    // Checks if room exists in db
    func checkRoomExists(roomCode: RoomCode, completionHandler: @escaping (Bool) -> Void) {
        if FirebaseInvalidStrings.isInvalid(name: roomCode.value) {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                completionHandler(false)
            })
            return
        }

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .observeSingleEvent(of: .value, with: { snapshot in
                completionHandler(snapshot.exists())
            })
    }

    // Check if room can be entered
    func checkRoomEnterable(roomCode: RoomCode, completionHandler: @escaping (GameRoomStatus) -> Void) {
        if FirebaseInvalidStrings.isInvalid(name: roomCode.value) {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                completionHandler(.invalid)
            })
            return
        }
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

    // User joins a room
    func joinRoom(roomCode: RoomCode) {
        if FirebaseInvalidStrings.isInvalid(name: roomCode.value) {
            return
        }

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    self.joinExistingRoom(roomCode: roomCode)
                }
            })

    }

    private func joinExistingRoom(roomCode: RoomCode) {
        guard let userID = getLoggedInUserID(), let username = getLoggedInUserName() else {
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

    // Get user's active non-rapid classic games
    func getUsersNonRapidGameRoomCodes(completionHandler: @escaping ([RoomCode]) -> Void) {
        guard let userID = getLoggedInUserID() else {
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

    // Observe user's active non-rapid classic games' turn status
    func observeNonRapidGamesTurn(
        roomCode: RoomCode,
        completionHandler: @escaping (_ isMyTurn: Bool, NonRapidClassicGame) -> Void
    ) {
        guard let userID = getLoggedInUserID() else {
            return
        }

        observingRoomCodes.insert(roomCode)

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .observe(.value, with: { snapshot in
                guard let roomValues = snapshot.value as? [String: Any],
                    let currRound = roomValues["currRound"] as? Int,
                    let playersDict = roomValues["players"] as? [String: [String: Any]],
                    let topicsDict = roomValues["topics"] as? [String: String] else {
                        return
                }

                // playersDict = [playerUID: [rounds: Any]]

                var players: [ClassicPlayer] = []
                playersDict.forEach { playerUID, values in
                    guard let isRoomMaster = values["isRoomMaster"] as? Bool,
                        let points = (values["points"] == nil) ? 0 : values["points"] as? Int,
                        let name = values["username"] as? String else {
                            return
                    }

                    players.append(ClassicPlayer(name: name, uid: playerUID,
                                                 isRoomMaster: isRoomMaster, points: points))
                }

                let topics: [String] = topicsDict.sorted { $0.key < $1.key }.map { $0.value }

                let nonRapidClassicGame = NonRapidClassicGame(roomCode: roomCode, players: players,
                                                              currentRound: currRound, topics: topics)

                // [round1: [hasUploadedImage: Any]]
                guard let userRounds = playersDict[userID]?["rounds"] as? [String: [String: Any]] else {
                        completionHandler(true, nonRapidClassicGame)
                        return
                }

                let hasUserDrawn = userRounds["round\(currRound)"]?["hasUploadedImage"] as? Bool ?? false

                completionHandler(!hasUserDrawn, nonRapidClassicGame)
            })
    }
}
