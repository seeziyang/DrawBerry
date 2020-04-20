//
//  RoomEnteringNetwork.swift
//  DrawBerry
//
//  Created by See Zi Yang on 14/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol RoomEnteringNetwork: NetworkInterface {
    func createRoom(roomCode: RoomCode)

    func checkRoomExists(roomCode: RoomCode, completionHandler: @escaping (Bool) -> Void)

    func checkRoomEnterable(roomCode: RoomCode, completionHandler: @escaping (GameRoomStatus) -> Void)

    func joinRoom(roomCode: RoomCode)

    func getUsersNonRapidGameRoomCodes(completionHandler: @escaping ([RoomCode]) -> Void)

    func observeNonRapidGamesTurn(
        roomCode: RoomCode,
        completionHandler: @escaping (_ isMyTurn: Bool, NonRapidClassicGame) -> Void
    )
}
