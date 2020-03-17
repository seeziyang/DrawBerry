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

    func joinRoom(roomCode: String) {
        db.child("activeRooms").child(roomCode).child("players")
            .child(NetworkHelper.getLoggedInUserID()).setValue(["isRoomMaster": false])
    }

    // TODO: add activeRoom room deletion from db when room/game ends
}
