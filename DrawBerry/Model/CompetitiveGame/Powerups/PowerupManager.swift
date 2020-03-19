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
    static let ALL_POWERUPS: [Powerup.Type] = [ChangeAlphaPowerup.self, ExtraStrokePowerup.self,
                                               InkSplotchPowerup.self]

    var allAvailablePowerups = [Powerup]()
    var powerupsToAdd = [Powerup]()
    var powerupsToRemove = [Powerup]()

    /// Rolls for powerups for all players. A powerup is randomly generated
    /// when the random value is less than `POWERUP_PROBABILITY`
    mutating func rollForPowerup(for players: [CompetitivePlayer]) {
        for player in players {
            let random = Double.random(in: 0...1)

            if random <= PowerupManager.POWERUP_PROBABILITY {

                guard let randomPowerupType = PowerupManager.ALL_POWERUPS.randomElement() else {
                    return
                }
                let powerup = generateRandomPowerup(powerupType: randomPowerupType, owner: player, players: players)

                allAvailablePowerups.append(powerup)
                powerupsToAdd.append(powerup)
            }
        }
    }

    /// Generates a random powerup from the list of powerups.
    func generateRandomPowerup(powerupType: Powerup.Type, owner: CompetitivePlayer,
                               players: [CompetitivePlayer]) -> Powerup {
        powerupType.init(owner: owner, players: players, location: getRandomLocation(for: owner))
    }

    private func getRandomLocation(for player: CompetitivePlayer) -> CGPoint {
        let playerFrame = player.canvasDrawing.frame
        let maxX = playerFrame.width - CGFloat(PowerupManager.POWERUP_RADIUS * 2)
        let maxY = playerFrame.height - CGFloat(PowerupManager.POWERUP_RADIUS * 2) - 50

        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        return CGPoint(x: randomX, y: randomY)
    }

    /// Applies the selected powerup. Activates a timer to deactivate the applied powerup if it is a `TogglePowerup`.
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
