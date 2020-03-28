//
//  CooperativeGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class CooperativeGame {
    weak var delegate: CooperativeGameDelegate?
    let networkAdapter: CooperativeGameNetworkAdapter
    let roomCode: RoomCode
    private(set) var players: [CooperativePlayer] {
        didSet {
            players.sort()
        }
    }
    let userIndex: Int // players contains user too
    var user: CooperativePlayer {
        players[userIndex]
    }
    private(set) var currentRound: Int
    var isLastPlayer: Bool {
        currentRound == userIndex.toOneBasedIndex()
    }
    var roundCompleted: Bool {
        currentRound > userIndex.toOneBasedIndex()
    }
    var isFirstPlayer: Bool {
        userIndex == 0
    }

    convenience init(from room: GameRoom) {
        self.init(from: room, networkAdapter: CooperativeGameNetworkAdapter(roomCode: room.roomCode))
    }

    init(from room: GameRoom, networkAdapter: CooperativeGameNetworkAdapter) {
        self.roomCode = room.roomCode
        self.networkAdapter = networkAdapter
        let sortedRoomPlayers = room.players.sorted()
        self.players = []
        for i in 0..<sortedRoomPlayers.count {
            self.players.append(CooperativePlayer(from: sortedRoomPlayers[i], index: i))
        }
        let userUID = NetworkHelper.getLoggedInUserID()
        self.userIndex = self.players.firstIndex(where: { $0.uid == userUID }) ?? 0
        self.currentRound = 1
    }

    func moveToNextRound() {
        currentRound += 1
        // TODO: update db
    }

    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    func waitForPreviousPlayerToFinish() {
        if userIndex == 0 {
            return
        }
        let previousPlayer = players[userIndex - 1]
        networkAdapter.waitAndDownloadPlayerDrawing(
            playerUID: previousPlayer.uid, forRound: currentRound, completionHandler: { [weak self] image in
                previousPlayer.addDrawing(image: image)
                self?.delegate?.navigateToDrawingPage()
            }
        )
    }
}

extension Int {
    // TODO put in separate file
    func toOneBasedIndex() -> Int {
        return self + 1
    }
}
