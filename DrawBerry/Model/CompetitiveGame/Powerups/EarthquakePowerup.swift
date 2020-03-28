//
//  RepeatingHiddenDrawingPowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 28/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class EarthquakePowerup: RepeatingTogglePowerup {
    static var ROTATION_VALUE = CGFloat.pi / 35
    var image = PowerupAssets.earthquakePowerupUIImage

    var owner: CompetitivePlayer
    var targets: [CompetitivePlayer]

    var description = "Earthquake!"

    var location: CGPoint
    var duration = Double.random(in: 0.045...0.065)
    var timesToRepeat = 25

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = players.filter { $0 != owner }
        self.location = location
    }

    func activate() {
        for target in targets {
            guard let newTransform = target.canvasProxy?.transform.rotated(by: EarthquakePowerup.ROTATION_VALUE) else {
                continue
            }
            target.canvasProxy?.transform = newTransform
        }

        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { _ in
            self.deactivate()
        }
    }

    func deactivate() {
        for target in targets {
            guard let newTransform = target.canvasProxy?.transform.rotated(by: -EarthquakePowerup.ROTATION_VALUE) else {
                continue
            }
            target.canvasProxy?.transform = newTransform
        }

        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { _ in
            self.timesToRepeat -= 1

            if self.timesToRepeat <= 0 {
                return
            }

            self.activate()
        }
    }
}
