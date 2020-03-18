//
//  GameRoom.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class GameRoom {
    static let maxPlayers = 8

    weak var delegate: GameRoomDelegate?
    private(set) var players: [RoomPlayer]
    let roomCode: String

    init(roomCode: String) {
        self.roomCode = roomCode
        players = []

        let db = Database.database().reference()

        db.child("activeRooms").child(roomCode).child("players")
            .observe(.value, with: { [weak self] snapshot in
                guard let playersValue = snapshot.value as? [String: [String: Bool]] else {
                    return
                }

                self?.players = playersValue.map { playerUID, properties in
                    RoomPlayer(name: playerUID, uid: playerUID,
                               isRoomMaster: properties["isRoomMaster"] ?? false)
                }

                self?.delegate?.playersDidUpdate()
            })
    }
}
