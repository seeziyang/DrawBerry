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
    weak var viewingDelegate: CooperativeGameViewingDelegate?
    let networkAdapter: GameNetworkAdapter
    let roomCode: RoomCode
    var allDrawings: [UIImage] = []
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
        userIndex == players.count - 1
    }
    var isFirstPlayer: Bool {
        userIndex == 0
    }

    convenience init(from room: GameRoom) {
        self.init(from: room, networkAdapter: GameNetworkAdapter(roomCode: room.roomCode))
    }

    init(from room: GameRoom, networkAdapter: GameNetworkAdapter) {
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

    func waitForPreviousPlayersToFinish() {
        if isFirstPlayer {
            return
        }
        let previousPlayers = players.filter { $0.index < userIndex }
        previousPlayers.forEach { downloadDrawing(of: $0) }
    }

    func downloadSubsequentDrawings() {
        let futurePlayers = players.filter { $0.index >= userIndex }
        futurePlayers.forEach { downloadDrawing(of: $0) }
    }

    func downloadDrawing(of player: CooperativePlayer) {
        networkAdapter.waitAndDownloadPlayerDrawing(
            playerUID: player.uid, forRound: currentRound, completionHandler: { [weak self] image in
                self?.allDrawings.append(image)
                self?.navigateIfUserIsNextPlayer(currentPlayer: player)
                self?.viewingDelegate?.updateDrawings()
                self?.navigateIfPlayerIsLast(currentPlayer: player)
            }
        )
    }

    func navigateIfUserIsNextPlayer(currentPlayer: CooperativePlayer) {
        if currentPlayer.index + 1 == userIndex {
            self.delegate?.changeMessageToGetReady()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.delegate?.navigateToDrawingPage()
            }
        }
    }

    func navigateIfPlayerIsLast(currentPlayer: CooperativePlayer) {
        if currentPlayer.index + 1 == players.count {
            self.viewingDelegate?.navigateToEndPage()
        }
    }
}
