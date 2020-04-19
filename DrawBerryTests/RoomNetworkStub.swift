//
//  RoomNetworkStub.swift
//  DrawBerryTests
//
//  Created by See Zi Yang on 14/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import Foundation

class RoomNetworkStub: RoomNetwork {
    let roomCode: RoomCode
    let admin1 = RoomPlayer(name: "admin1", uid: "I1jcaAauaUQWp7uHuyMHlyDZRlP2", isRoomMaster: true)
    let admin2 = RoomPlayer(name: "admin2", uid: "xYbVyQTsJbXOnTXDh2Aw8b1VMYG2")

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
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            listener([self.admin1, self.admin2])
        })
    }

    func observeGameStart(listener: @escaping (Bool) -> Void) {
    }

    func observeIsRapidToggle(listener: @escaping (Bool) -> Void) {
    }

    func stopObservingGameStart() {
    }

    func getLoggedInUserID() -> String? {
        return nil
    }

    func getLoggedInUserName() -> String? {
        return nil
    }
}
