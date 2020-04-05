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
    static let minStartablePlayers = 1 // for testing, change to 3 for game

    weak var delegate: GameRoomDelegate?
    let roomNetworkAdapter: RoomNetworkAdapter
    let roomCode: RoomCode
    private(set) var isRapid: Bool
    private(set) var players: [RoomPlayer] { // synced with database
        didSet {
            players.sort()
        }
    }
    var user: RoomPlayer? {
        players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
    }

    var status: GameRoomStatus {
        if players.count < GameRoom.maxPlayers {
            return .enterable
        } else {
            return .full
        }
    }

    var canStart: Bool {
        players.count >= GameRoom.minStartablePlayers && players.count <= GameRoom.maxPlayers
    }

    convenience init(roomCode: RoomCode) {
        self.init(roomCode: roomCode, roomNetworkAdapter: RoomNetworkAdapter(roomCode: roomCode))
    }

    init(roomCode: RoomCode, roomNetworkAdapter: RoomNetworkAdapter) {
        self.roomNetworkAdapter = roomNetworkAdapter
        self.roomCode = roomCode
        self.players = []
        self.isRapid = true

        roomNetworkAdapter.observeRoomPlayers(listener: { [weak self] players in
            self?.players = players
            self?.delegate?.playersDidUpdate()
        })

        roomNetworkAdapter.observeGameStart(listener: { [weak self] hasStarted in
            if hasStarted {
                self?.delegate?.gameHasStarted()
            }
        })

        roomNetworkAdapter.observeIsRapidToggle(listener: { [weak self] isRapid in
            self?.isRapid = isRapid
            self?.delegate?.isRapidDidUpdate(isRapid: isRapid)
        })
    }

    func startGame() {
        roomNetworkAdapter.startGame(isRapid: isRapid)
    }

    func leaveRoom() {
        let isLastPlayer = players.count == 1
        if isLastPlayer {
            roomNetworkAdapter.deleteRoom()
        } else {
            roomNetworkAdapter.leaveRoom(isRoomMaster: user?.isRoomMaster ?? false)
        }
    }

    func toggleIsRapid() {
        isRapid.toggle()
        roomNetworkAdapter.setIsRapid(isRapid: isRapid)
    }
}
