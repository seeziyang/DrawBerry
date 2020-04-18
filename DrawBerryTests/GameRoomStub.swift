//
//  GameRoomStub.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 17/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import XCTest

class GameRoomStub: GameRoom {
    override init(roomCode: RoomCode, roomNetwork: RoomNetwork) {
        super.init(roomCode: roomCode, roomNetwork: roomNetwork)
        self.players = [TestConstants.admin1, TestConstants.admin2, TestConstants.admin3]
    }
}
