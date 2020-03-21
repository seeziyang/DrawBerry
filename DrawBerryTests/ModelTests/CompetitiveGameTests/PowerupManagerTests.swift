//
//  PowerupManagerTests.swift
//  DrawBerryTests
//
//  Created by Jon Chua on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class PowerupManagerTests: XCTestCase {
    var powerupManager: PowerupManager!
    var players: [CompetitivePlayer]!

    override func setUp() {
        super.setUp()
        powerupManager = PowerupManager()
        players = []

        for i in 0..<4 {
            let canvas = BerryCanvas()
            canvas.frame = CGRect(x: 100, y: 100, width: 500, height: 500)

            let player = CompetitivePlayer(name: "Player \(i)", canvasDrawing: canvas)
            players.append(player)
        }
    }

    func testChangeAlphaPowerup() {
        let selectedPlayer = players[0]
        let powerup = ChangeAlphaPowerup(owner: selectedPlayer, players: players,
                                         location: powerupManager.getRandomLocation(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            XCTAssertEqual(player.canvasDrawing.alpha, ChangeAlphaPowerup.ALPHA_VALUE, accuracy: 1e-6,
                           "Player's alpha value was not changed")
        }

        XCTAssertEqual(selectedPlayer.canvasDrawing.alpha, ChangeAlphaPowerup.DEFAULT_VALUE, accuracy: 1e-6,
                       "Selected player's alpha value was changed")
    }

    func testExtraStrokePowerup() {
        let selectedPlayer = players[1]
        let powerup = ExtraStrokePowerup(owner: selectedPlayer, players: players,
                                         location: powerupManager.getRandomLocation(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            XCTAssertEqual(player.extraStrokes, 0, "Other player's extra stroke was changed")
        }

        XCTAssertEqual(selectedPlayer.extraStrokes, 1, "Selected player's extra stroke was not incremented")
    }

    func testStressPowerup() {
        for _ in 0...10_000 {
            guard let randomPlayer = players.randomElement(),
                let powerup = powerupManager.generateRandomPowerup(owner: randomPlayer, players: players) else {
                XCTFail("Failed to create powerup")
                break
            }
            powerupManager.applyPowerup(powerup)
        }
    }
}
