//
//  PowerupManager.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

struct PowerupManager {
    static let POWERUP_PROBABILITY = 0.000_5
    static let POWERUP_RADIUS: CGFloat = 20

    var allAvailablePowerups = [Powerup]()
    var powerupsToAdd = [Powerup]()
    var powerupsToRemove = [Powerup]()

    mutating func rollForPowerup(for players: [Player]) {
        for player in players {
            let random = Double.random(in: 0...1)

            if random <= PowerupManager.POWERUP_PROBABILITY {
                let powerup = ChangeAlphaPowerup(targets: players.filter { $0 != player },
                                                 location: getRandomLocation(for: player))
                allAvailablePowerups.append(powerup)
                powerupsToAdd.append(powerup)
            }
        }
    }

    private func getRandomLocation(for player: Player) -> CGPoint {
        let playerFrame = player.canvasDrawing.frame
        let maxX = playerFrame.width - CGFloat(PowerupManager.POWERUP_RADIUS * 2)
        let maxY = playerFrame.height - CGFloat(PowerupManager.POWERUP_RADIUS * 2) - 50

        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        return CGPoint(x: playerFrame.origin.x + randomX, y: playerFrame.origin.y + randomY)
    }

    mutating func applyPowerup(_ powerup: Powerup) {
        powerup.activate()

        if let togglePowerup = powerup as? TogglePowerup {
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(togglePowerup.duration), repeats: false) { timer in
                togglePowerup.deactivate()
                timer.invalidate()
            }
        }

        removePowerupFromArray(&allAvailablePowerups, powerup)
        powerupsToRemove.append(powerup)
    }

    private func removePowerupFromArray(_ arr: inout [Powerup], _ powerup: Powerup) {
        arr = arr.filter { $0.location != powerup.location }
    }
}
