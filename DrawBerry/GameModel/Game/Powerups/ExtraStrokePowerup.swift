//
//  ExtraStrokePowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

struct ExtraStrokePowerup: LastingPowerup {
    var targets: [Player]
    var location: CGPoint

    init(targets: [Player], location: CGPoint) {
        self.targets = targets
        self.location = location
    }

    mutating func activate() {
        for target in targets {
            target.extraStrokes += 1
        }
    }
}
