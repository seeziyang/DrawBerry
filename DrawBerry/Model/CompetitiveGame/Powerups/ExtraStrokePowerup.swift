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
    var targets: [CompetitivePlayer]
    var location: CGPoint

    init(targets: [CompetitivePlayer], location: CGPoint) {
        self.targets = targets
        self.location = location
    }

    func activate() {
        for target in targets {
            target.extraStrokes += 1
        }
    }
}
