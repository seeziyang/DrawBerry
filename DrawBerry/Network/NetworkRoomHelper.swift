//
//  NetworkRoomHelper.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class NetworkRoomHelper {

    let db: DatabaseReference

    init() {
        db = Database.database().reference()
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
        db.child("activeRooms").child(roomCode).child("players")
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let playersValue = snapshot.value as? [String: [String: Bool]] else {
                    completionHandler(.doesNotExist) // room does not exists
                    return
                }

                let isNotFull = playersValue.count <= GameRoom.maxPlayers
                completionHandler(isNotFull ? .enterable : .full)
            })
    }

    func joinRoom(roomCode: String) {
        db.child("activeRooms").child(roomCode).child("players")
            .child(NetworkHelper.getLoggedInUserID()).setValue(["isRoomMaster": false])
    }

    // TODO: add activeRoom room deletion from db when room/game ends

    // TODO: delete player from active room if he leaves

    // Todo remove observer when room/game ends

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
}
