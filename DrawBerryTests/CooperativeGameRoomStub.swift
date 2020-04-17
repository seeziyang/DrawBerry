//
//  GameRoomStub.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 17/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class CooperativeGameRoomStub: CooperativeGameRoom {
    let admin1 = RoomPlayer(name: "admin1", uid: "I1jcaAauaUQWp7uHuyMHlyDZRlP2", isRoomMaster: true)
    let admin2 = RoomPlayer(name: "admin2", uid: "xYbVyQTsJbXOnTXDh2Aw8b1VMYG2")

    override init(roomCode: RoomCode, roomNetwork: RoomNetwork) {
        super.init(roomCode: roomCode, roomNetwork: roomNetwork)
        self.players = [admin1, admin2]
    }
}
