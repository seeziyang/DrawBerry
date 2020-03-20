//
//  TestTogglePowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ChangeAlphaPowerup: TogglePowerup {
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
            target.canvasDrawing.alpha = 0.3
        }
    }

    func deactivate() {
        for target in targets {
            target.canvasDrawing.alpha = 1
        }
    }
}
