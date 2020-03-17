//
//  TestTogglePowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

struct ChangeAlphaPowerup: TogglePowerup {
    var duration: Double
    var targets: [Player]
    var location: CGPoint

    init(targets: [Player], location: CGPoint) {
        self.targets = targets
        self.location = location
        self.duration = 1.0
    }

    func activate() {
        print("Powerup activated!")
        for target in targets {
            target.canvasDrawing.alpha = 0.1
        }
    }

    func deactivate() {
        print("Powerup deactivated!")
        for target in targets {
            target.canvasDrawing.alpha = 1
        }
    }
}
