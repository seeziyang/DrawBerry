//
//  CooperativeGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class CooperativeGame: MultiplayerNetworkGame {
    var players: [CooperativePlayer]
    var user: CooperativePlayer
    var allDrawings: [UIImage]
    var currentRound: Int
    let maxRounds: Int = 1
    var isFirstPlayer: Bool {
        players[0] == user
    }

    let gameNetwork: GameNetwork
    let roomCode: RoomCode

    weak var delegate: CooperativeGameDelegate?
    weak var viewingDelegate: CooperativeGameViewingDelegate?

    init(from room: GameRoom) {
        let players = room.players.sorted().map { CooperativePlayer(from: $0) }
        self.players = players
        self.user = players.first(where: { $0.uid == NetworkHelper.getLoggedInUserID() }) ?? players[0]
        self.allDrawings = []
        self.currentRound = 1

        self.gameNetwork = FirebaseGameNetworkAdapter(roomCode: room.roomCode)
        self.roomCode = room.roomCode
    }

    /// Download drawings of players before the user.
    func downloadPreviousDrawings() {
        if isFirstPlayer {
            return
        }
        guard let userIndex = getIndex(of: user) else {
            return
        }
        let previousPlayers = players.filter { getIndex(of: $0) ?? 0 < userIndex }
        previousPlayers.forEach { downloadDrawing(of: $0) }
    }

    /// Downloads the subsequent drawings by observing for uploads.
    func downloadSubsequentDrawings() {
        guard let userIndex = getIndex(of: user) else {
            return
        }
        let futurePlayers = players.filter { getIndex(of: $0) ?? 0 >= userIndex }
        futurePlayers.forEach { downloadDrawing(of: $0) }
    }

    /// Downloads the drawing of the given player once it is available.
    private func downloadDrawing(of player: CooperativePlayer) {
        observe(player: player, for: currentRound, completionHandler: { [weak self] image in
                self?.allDrawings.append(image)
                self?.navigateIfUserIsNextPlayer(currentPlayer: player)
                self?.viewingDelegate?.updateDrawings()
                self?.navigateIfPlayerIsLast(currentPlayer: player)
            }
        )
    }

    /// Navigates to the drawing screen if user is the next player.
    private func navigateIfUserIsNextPlayer(currentPlayer: CooperativePlayer) {
        guard let currentPlayerIndex = getIndex(of: currentPlayer),
            let userIndex = getIndex(of: user) else {
                return
        }
        if currentPlayerIndex + 1 == userIndex {
            self.delegate?.changeMessageToGetReady()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.delegate?.navigateToDrawingPage()
            }
        }
    }

    /// Navigates to the end screen if user is the last player.
    private func navigateIfPlayerIsLast(currentPlayer: CooperativePlayer) {
        guard let currentPlayerIndex = getIndex(of: currentPlayer) else {
            return
        }
        if currentPlayerIndex + 1 == players.count {
            self.viewingDelegate?.navigateToEndPage()
        }
    }

    /// Ends the game in the network.
    func endGame() {
        endGame(isRoomMaster: user.isRoomMaster, numRounds: currentRound)
    }
}
