//
//  RoomNetworkAdapter.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class FirebaseRoomNetworkAdapter: RoomNetwork, FirebaseNetworkAdapter {
    let db: DatabaseReference
    let roomCode: RoomCode

    init(roomCode: RoomCode) {
        self.db = Database.database().reference()
        self.roomCode = roomCode
    }

    deinit {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
        dbPathRef.child("players").removeAllObservers()
        dbPathRef.child("hasStarted").removeAllObservers()
        dbPathRef.child("isRapid").removeAllObservers()
        dbPathRef.removeAllObservers()
    }

    // User leaves room he is in
    func leaveRoom(isRoomMaster: Bool) {
        guard let userID = getLoggedInUserID() else {
            return
        }

        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)

        if isRoomMaster {
            dbPathRef.removeValue(completionBlock: { [weak self] _, _ in
                self?.handoverRoomMaster()
            })
        } else {
            dbPathRef.removeValue()
        }

    }

    // If the room master leaves the room, handover room master to another player
    private func handoverRoomMaster() {
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

    // Delete room from db when last player leaves
    func deleteRoom() {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .removeValue()
    }

    // Set room's game isRapid in db
    func setIsRapid(isRapid: Bool) {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("isRapid")
            .setValue(isRapid)
    }

    // Set hasStarted to true in db
    func startGame(isRapid: Bool) {
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
                        guard let roomCode = self?.roomCode else {
                            return
                        }

                        self?.db.child("users")
                            .child(playerUID)
                            .child("activeNonRapidGames")
                            .child(roomCode.value)
                            .setValue(true)
                    }
                })
        }
    }

    // Observe for players entering or leaving the user's room
    func observeRoomPlayers(listener: @escaping ([RoomPlayer]) -> Void) {
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

    // Observe to see if game has started by another player in db
    func observeGameStart(listener: @escaping (Bool) -> Void) {
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

    // Observe to see if isRapid is toggled by room master
    func observeIsRapidToggle(listener: @escaping (Bool) -> Void) {
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

    func stopObservingGameStart() {
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("hasStarted")
            .removeAllObservers()
    }
}
