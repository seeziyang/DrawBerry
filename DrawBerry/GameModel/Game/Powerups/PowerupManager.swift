//
//  PowerupManager.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class PowerupManager {
    static let POWERUP_PROBABILITY = 0.000_35
    static let POWERUP_RADIUS = 40

    var allPowerups = [Powerup]()
    var powerupsToAdd = [Powerup]()
    var powerupsToRemove = [Powerup]()

    func rollForPowerup(for players: [Player]) {
        powerupsToAdd = []

        for player in players {
            let random = Double.random(in: 0...1)

            if random <= PowerupManager.POWERUP_PROBABILITY {
                let powerup = ChangeAlphaPowerup(targets: players.filter { $0 != player },
                                                 location: getRandomLocation(for: player))
                allPowerups.append(powerup)
                powerupsToAdd.append(powerup)
            }
        }
    }

    private func getRandomLocation(for player: Player) -> CGPoint {
        let playerFrame = player.canvasDrawing.frame
        let maxX = playerFrame.width - CGFloat(PowerupManager.POWERUP_RADIUS)
        let maxY = playerFrame.height - CGFloat(PowerupManager.POWERUP_RADIUS)

        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        return CGPoint(x: playerFrame.origin.x + randomX,
                       y: playerFrame.origin.y + randomY)
    }

    func applyPowerup(_ powerup: Powerup) {
        switch powerup {
        case var togglePowerup as TogglePowerup:

            // Disable the powerup after duration is over
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(togglePowerup.duration), repeats: false) { timer in
                togglePowerup.deactivate()
                timer.invalidate()
            }

            togglePowerup.activate()
        case var lastingPowerup as LastingPowerup:
            lastingPowerup.activate()
        default:
            print("Unrecognized powerup")
        }
    }
}
