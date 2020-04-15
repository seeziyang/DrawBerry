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
    var targetCanvases = [Canvas]()

    var description = Message.earthquakePowerup

    var location: CGPoint
    var duration = Double.random(in: 0.045...0.065)

    static var TOTAL_TIMES = 25
    var timesToRepeat = EarthquakePowerup.TOTAL_TIMES

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = players.filter { $0 != owner }
        self.location = location
    }

    func activate() {
        targets.forEach { $0.canvasDrawing.rotateCanvas(by: EarthquakePowerup.ROTATION_VALUE) }

        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { _ in
            self.deactivate()
        }
    }

    func deactivate() {
        targets.forEach { $0.canvasDrawing.rotateCanvas(by: -EarthquakePowerup.ROTATION_VALUE) }

        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { _ in
            self.timesToRepeat -= 1
            if self.timesToRepeat <= 0 {
                return
            }

            self.activate()
        }
    }
}
