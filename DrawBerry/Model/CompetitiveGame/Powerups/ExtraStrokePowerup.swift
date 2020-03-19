//
//  ExtraStrokePowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ExtraStrokePowerup: Powerup {
    var image = PowerupAssets.extraStrokePowerupUIImage

    var owner: CompetitivePlayer
    var targets: [CompetitivePlayer]
    var location: CGPoint

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = [owner]
        self.location = location
    }

    func activate() {
        for target in targets {
            target.extraStrokes += 1
        }
    }
}
