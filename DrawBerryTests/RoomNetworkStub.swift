//
//  RoomNetworkStub.swift
//  DrawBerryTests
//
//  Created by See Zi Yang on 14/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class RoomNetworkStub: RoomNetwork {
    let roomCode: RoomCode

    init(roomCode: RoomCode) {
        self.roomCode = roomCode
    }

    func leaveRoom(isRoomMaster: Bool) {
    }

    func deleteRoom() {
    }

    func setIsRapid(isRapid: Bool) {
    }

    func startGame(isRapid: Bool) {
    }

    func observeRoomPlayers(listener: @escaping ([RoomPlayer]) -> Void) {
    }

    func observeGameStart(listener: @escaping (Bool) -> Void) {
    }

    func observeIsRapidToggle(listener: @escaping (Bool) -> Void) {
    }

    func stopObservingGameStart() {
    }
}
