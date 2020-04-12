//
//  DrawOutOfBoundsPowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 19/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class InkSplotchPowerup: Powerup {
    var image = PowerupAssets.inksplotchPowerupUIImage

    var owner: CompetitivePlayer
    var targets: [CompetitivePlayer]
    var location: CGPoint

    var description = Message.inkSplotchPowerup

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = players.filter { $0 != owner }
        self.location = location
    }

    func activate() {
        targets.forEach { $0.canvasDrawing.addInkSplotch() }
    }

    func deactivate() {
    }
}
