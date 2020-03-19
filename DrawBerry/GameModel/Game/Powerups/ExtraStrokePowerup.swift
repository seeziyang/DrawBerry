//
//  ExtraStrokePowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ExtraStrokePowerup: Powerup {
    var image = PowerupAssets.extraStrokeUIImage

    var owner: Player
    var targets: [Player]

    var location: CGPoint

    init(owner: Player, targets: [Player], location: CGPoint) {
        self.owner = owner
        self.targets = targets
        self.location = location
    }

    func activate() {
        for target in targets {
            target.extraStrokes += 1
        }
    }
}
