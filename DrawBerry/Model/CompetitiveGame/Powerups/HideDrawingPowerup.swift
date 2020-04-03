//
//  HideDrawingPowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class HideDrawingPowerup: TogglePowerup {
    static let DELTA_VALUE: CGFloat = 0.7

    var image = PowerupAssets.hideDrawingPowerupUIImage

    var owner: CompetitivePlayer
    var targets: [CompetitivePlayer]
    var targetCanvases = [Canvas]()

    var description = Message.hiddenDrawingPowerup

    var location: CGPoint
    var duration = 1.0

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = players.filter { $0 != owner }
        self.location = location
    }

    func activate() {
        targetCanvases = targets.compactMap { $0.canvasProxy }
        targetCanvases.forEach { $0.isHidden = true }

        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { timer in
            self.deactivate()
            timer.invalidate()
        }
    }

    func deactivate() {
        targetCanvases.forEach { $0.isHidden = false }
    }
}
