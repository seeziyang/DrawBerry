//
//  MultiplayerNetworkGame.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

protocol MultiplayerNetworkGame: NetworkGame, MultiplayerGame {
    var user: GamePlayer { get set }
    var maxRounds: Int { get }
    var isLastRound: Bool { get }

    /// Adds a `UIImage` to the associated user.
    func addUsersDrawing(image: UIImage)

    func getIndex(of player: GamePlayer) -> Int?
}

extension MultiplayerNetworkGame {
    var isLastRound: Bool {
        currentRound == maxRounds
    }

    func addUsersDrawing(image: UIImage) {
        user.addDrawing(image: image)
        upload(image: image, for: currentRound)
    }

    func getIndex(of player: GamePlayer) -> Int? {
        players.firstIndex(where: { $0.uid == player.uid })
    }
}
