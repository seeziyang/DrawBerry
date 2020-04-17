//
//  CooperativeGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class CooperativeGame: MultiplayerNetworkGame {
    weak var delegate: CooperativeGameDelegate?
    weak var viewingDelegate: CooperativeGameViewingDelegate?
    var isFirstPlayer: Bool {
        players[0] == user
    }
    var cooperativePlayers: [CooperativePlayer] {
        players.compactMap { $0 as? CooperativePlayer }
    }

    init(from room: GameRoom) {
        super.init(from: room, maxRounds: 1)
    }

    /// Download drawings of players before the user.
    func downloadPreviousDrawings() {
        if isFirstPlayer {
            return
        }
        guard let userIndex = getIndex(of: user) else {
            return
        }
        cooperativePlayers
            .filter { getIndex(of: $0) ?? 0 < userIndex }
            .forEach { downloadDrawing(of: $0, completionHandler: previousDrawingsCompletionHandler) }
    }

    /// Downloads the subsequent drawings by observing for uploads.
    func downloadSubsequentDrawings() {
        guard let userIndex = getIndex(of: user) else {
            return
        }
        cooperativePlayers
            .filter { getIndex(of: $0) ?? 0 >= userIndex }
            .forEach { downloadDrawing(of: $0, completionHandler: futureDrawingsCompletionHandler) }
    }

    /// Downloads the drawing of the given player once it is available.
    private func downloadDrawing(of player: CooperativePlayer,
                                 completionHandler: @escaping (UIImage, CooperativePlayer) -> Void) {
        observe(player: player, for: currentRound, completionHandler: { image in
            completionHandler(image, player)
        })
    }

    private func previousDrawingsCompletionHandler(image: UIImage, player: CooperativePlayer) {
        allDrawings.append(image)
        navigateIfUserIsNextPlayer(currentPlayer: player)
        navigateIfPlayerIsLast(currentPlayer: player)
    }

    private func futureDrawingsCompletionHandler(image: UIImage, player: CooperativePlayer) {
        allDrawings.append(image)
        viewingDelegate?.updateDrawings()
        navigateIfPlayerIsLast(currentPlayer: player)
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
