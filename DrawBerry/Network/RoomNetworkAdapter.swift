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
    private var observingRoomCode: String?

    init() {
        self.db = Database.database().reference()
    }

    deinit {
        if let observingRoomCode = observingRoomCode {
            let dbPathRef = db.child("activeRooms").child(observingRoomCode)
            dbPathRef.child("player").removeAllObservers()
            dbPathRef.child("hasStarted").removeAllObservers()
        }
    }

    func createRoom(roomCode: String) {
        db.child("activeRooms").child(roomCode).child("players")
            .child(NetworkHelper.getLoggedInUserID()).setValue(["isRoomMaster": true])
    }

    func checkRoomExists(roomCode: String, completionHandler: @escaping (Bool) -> Void) {
        db.child("activeRooms").child(roomCode).observeSingleEvent(of: .value, with: { snapshot in
            completionHandler(snapshot.exists())
        })
    }

    func checkRoomEnterable(roomCode: String, completionHandler: @escaping (GameRoomStatus) -> Void) {
        db.child("activeRooms").child(roomCode)
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

                let isNotFull = numPlayers <= GameRoom.maxPlayers
                completionHandler(isNotFull ? .enterable : .full)
            })
    }

    func joinRoom(roomCode: String) {
        db.child("activeRooms").child(roomCode).child("players")
            .child(NetworkHelper.getLoggedInUserID()).child("isRoomMaster").setValue(false)
    }

    func startGame(roomCode: String) {
        db.child("activeRooms").child(roomCode).child("hasStarted").setValue(true)
    }

    // TODO: add activeRoom room deletion from db when room/game ends

    // TODO: delete player from active room if he leaves

    func observeRoomPlayers(roomCode: String, listener: @escaping ([RoomPlayer]) -> Void) {
        db.child("activeRooms").child(roomCode).child("players")
            .observe(.value, with: { snapshot in
                guard let playersValue = snapshot.value as? [String: [String: Bool]] else {
                    return
                }

                let players = playersValue.map { playerUID, properties in
                    RoomPlayer(name: playerUID, uid: playerUID,
                               isRoomMaster: properties["isRoomMaster"] ?? false)
                }

                listener(players)
            })
    }

    func observeGameStart(roomCode: String, listener: @escaping (Bool) -> Void) {
        db.child("activeRooms").child(roomCode).child("hasStarted")
            .observe(.value, with: { snapshot in
                guard let hasStartedValue = snapshot.value as? Bool else {
                    return
                }

                listener(hasStartedValue)
            })
    }
}
