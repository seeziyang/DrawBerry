//
//  HideDrawingPowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class HideDrawingPowerup: TogglePowerup {
    var image = PowerupAssets.hideDrawingPowerupUIImage

    var owner: CompetitivePlayer
    var targets: [CompetitivePlayer]

    var description = Message.hiddenDrawingPowerup

    var location: CGPoint
    var duration = 1.0

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = players.filter { $0 != owner }
        self.location = location
    }

    func activate() {
        targets.forEach { $0.canvasDrawing.hideDrawing() }

        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { timer in
            self.deactivate()
            timer.invalidate()
        }
    }

    func deactivate() {
        targets.forEach { $0.canvasDrawing.showDrawing() }
    }
}
