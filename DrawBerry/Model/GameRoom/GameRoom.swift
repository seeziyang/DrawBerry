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
    static let minStartablePlayers = 1 // for testing, set to 2 for non-testing

    weak var delegate: GameRoomDelegate?
    let roomNetwork: RoomNetwork
    let roomCode: RoomCode
    private(set) var isRapid: Bool
    var players: [RoomPlayer] { // synced with database
        didSet {
            players.sort()
        }
    }

    var didPlayersCountChange: Bool?
    var user: RoomPlayer? {
        players.first(where: { $0.uid == roomNetwork.getLoggedInUserID() })
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
        self.init(roomCode: roomCode, roomNetwork: FirebaseRoomNetworkAdapter(roomCode: roomCode))
    }

    init(roomCode: RoomCode, roomNetwork: RoomNetwork) {
        self.roomNetwork = roomNetwork
        self.roomCode = roomCode
        self.players = []
        self.isRapid = true

        roomNetwork.observeRoomPlayers(listener: { [weak self] players in
            if let previousPlayers = self?.players {
                self?.didPlayersCountChange = (previousPlayers.count != players.count)
            }
            self?.players = players
            self?.delegate?.playersDidUpdate()
        })

        roomNetwork.observeGameStart(listener: { [weak self] hasStarted in
            if hasStarted {
                self?.delegate?.gameHasStarted()
            }
        })

        roomNetwork.observeIsRapidToggle(listener: { [weak self] isRapid in
            self?.isRapid = isRapid
            self?.delegate?.isRapidDidUpdate(isRapid: isRapid)
        })
    }

    func startGame() {
        roomNetwork.stopObservingGameStart()
        roomNetwork.startGame(isRapid: isRapid)
    }

    func leaveRoom() {
        let isLastPlayer = players.count == 1
        if isLastPlayer {
            roomNetwork.deleteRoom()
        } else {
            roomNetwork.leaveRoom(isRoomMaster: user?.isRoomMaster ?? false)
        }
    }

    func toggleIsRapid() {
        isRapid.toggle()
        roomNetwork.setIsRapid(isRapid: isRapid)
    }
}
