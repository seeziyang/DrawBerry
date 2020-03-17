//
//  PowerupManager.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class PowerupManager {
    static let POWERUP_PROBABILITY = 0.000_375

    var allPowerups = [Powerup]()

    func rollForPowerup(for players: [Player]) {
        for player in players {
            let random = Double.random

            if random <= PowerupManager.POWERUP_PROBABILITY {
                let powerup = ChangeAlphaPowerup(targets: players.filter { $0 != player }, location: CGPoint.zero)
                allPowerups.append(powerup)

                // Just for testing purposes
                applyPowerup(powerup)
            }
        }
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

extension Double {
    static var random: Double {
        Double(arc4random()) / 0xFFFFFFFF
    }
}
