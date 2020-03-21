//
//  TestTogglePowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ChangeAlphaPowerup: TogglePowerup {
    static let ALPHA_VALUE: CGFloat = 0.3
    static let DEFAULT_VALUE: CGFloat = 1.0

    var image = PowerupAssets.changeAlphaPowerupUIImage

    var owner: CompetitivePlayer
    var targets: [CompetitivePlayer]

    var location: CGPoint
    var duration = 1.0

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = players.filter { $0 != owner }
        self.location = location
    }

    func activate() {
        for target in targets {
            target.canvasDrawing.alpha = ChangeAlphaPowerup.ALPHA_VALUE
        }
    }

    func deactivate() {
        for target in targets {
            target.canvasDrawing.alpha = ChangeAlphaPowerup.DEFAULT_VALUE
        }
    }
}
