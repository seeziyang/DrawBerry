//
//  CooperativeGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class CooperativeGame: Game {
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
    let userIndex: Int
    var user: CooperativePlayer {
        players[userIndex]
    }
    private(set) var currentRound: Int
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
        self.userIndex = self.players.firstIndex(where: { $0.uid == NetworkHelper.getLoggedInUserID() })
            ?? 0
        self.currentRound = 1
    }

    /// Adds a `UIImage` to the associated user.
    func addUsersDrawing(image: UIImage) {
        user.drawingImage = image
        networkAdapter.uploadUserDrawing(image: image, forRound: currentRound)
    }

    /// Download drawings of players before the user.
    func downloadPreviousDrawings() {
        if isFirstPlayer {
            return
        }
        let previousPlayers = players.filter { $0.index < userIndex }
        previousPlayers.forEach { downloadDrawing(of: $0) }
    }

    /// Downloads the subsequent drawings by observing for uploads.
    func downloadSubsequentDrawings() {
        let futurePlayers = players.filter { $0.index >= userIndex }
        futurePlayers.forEach { downloadDrawing(of: $0) }
    }

    /// Downloads the drawing of the given player once it is available.
    private func downloadDrawing(of player: CooperativePlayer) {
        networkAdapter.waitAndDownloadPlayerDrawing(
            playerUID: player.uid, forRound: currentRound, completionHandler: { [weak self] image in
                self?.allDrawings.append(image)
                self?.navigateIfUserIsNextPlayer(currentPlayer: player)
                self?.viewingDelegate?.updateDrawings()
                self?.navigateIfPlayerIsLast(currentPlayer: player)
            }
        )
    }

    /// Navigates to the drawing screen if user is the next player.
    private func navigateIfUserIsNextPlayer(currentPlayer: CooperativePlayer) {
        if currentPlayer.index + 1 == userIndex {
            self.delegate?.changeMessageToGetReady()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.delegate?.navigateToDrawingPage()
            }
        }
    }

    /// Navigates to the end screen if user is the last player.
    private func navigateIfPlayerIsLast(currentPlayer: CooperativePlayer) {
        if currentPlayer.index + 1 == players.count {
            self.viewingDelegate?.navigateToEndPage()
        }
    }

    /// Ends the game in the network.
    func endGame() {
        networkAdapter.endGame(isRoomMaster: user.isRoomMaster, numRounds: currentRound)
    }
}
