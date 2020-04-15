//
//  PowerupTests.swift
//  DrawBerryTests
//
//  Created by Jon Chua on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class PowerupTests: XCTestCase {
    var powerupManager: PowerupManager!
    var players: [CompetitivePlayer]!

    override func setUp() {
        super.setUp()
        powerupManager = PowerupManager()
        players = []

        for i in 0..<4 {
            let frame = CGRect(x: 100, y: 100, width: 500, height: 500)
            guard let canvas = CompetitiveBerryCanvas.createCompetitiveCanvas(within: frame) else {
                XCTFail("Failed to create canvas")
                break
            }

            let player = CompetitivePlayer(name: "Player \(i)", canvasDrawing: canvas)
            players.append(player)
        }
    }

    func testHideDrawingPowerup() {
        let selectedPlayer = players[0]
        let powerup = HideDrawingPowerup(owner: selectedPlayer, players: players,
                                         location: CGPoint.randomLocation(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            XCTAssertTrue(player.canvasDrawing.isHidden, "Target's drawing was not hidden")
        }

        XCTAssertFalse(selectedPlayer.canvasDrawing.isHidden, "Owner's drawing was hidden")

        powerup.deactivate()

        for player in players {
            XCTAssertFalse(player.canvasDrawing.isHidden,
                           "Player's drawing was not unhidden after powerup deactivation")
        }
    }

    func testExtraStrokePowerup() {
        let selectedPlayer = players[1]
        let powerup = ExtraStrokePowerup(owner: selectedPlayer, players: players,
                                         location: CGPoint.randomLocation(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            XCTAssertEqual(player.extraStrokes, 0, "Other player's extra stroke was changed")
        }

        XCTAssertEqual(selectedPlayer.extraStrokes, 1, "Selected player's extra stroke was not incremented")
    }

    func testInkSplotchPowerup() {
        let selectedPlayer = players[2]
        let powerup = InkSplotchPowerup(owner: selectedPlayer, players: players,
                                        location: CGPoint.randomLocation(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            XCTAssertEqual(player.canvasDrawing.subviews.count,
                           selectedPlayer.canvasDrawing.subviews.count + 1, "Ink splotch was not added to targets")
        }
    }

    func testInvulnerabilityPowerup() {
        let selectedPlayer = players[3]
        let powerup = InvulnerabilityPowerup(owner: selectedPlayer, players: players,
                                             location: CGPoint.randomLocation(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        XCTAssertTrue(selectedPlayer.canvasDrawing is InvulnerableBerryCanvas, "Owner is not invulnerable")
        for player in players where player != selectedPlayer {
            XCTAssertFalse(player.canvasDrawing is InvulnerableBerryCanvas, "Other players were invulnerable")
        }

        powerup.deactivate()
        for player in players {
            XCTAssertFalse(player.canvasDrawing is InvulnerableBerryCanvas,
                           "Players were invulnerable after powerup deactivation")
        }
    }

    func testHideDrawingWhileInvulnerable() {
        let selectedPlayer = players[0]
        let otherPlayer = players[1]
        let invulnerabilityPowerup = InvulnerabilityPowerup(owner: selectedPlayer, players: players,
                                                            location: CGPoint.randomLocation(for: selectedPlayer))
        powerupManager.applyPowerup(invulnerabilityPowerup)

        let hideDrawingPowerup = HideDrawingPowerup(owner: otherPlayer, players: players,
                                                    location: CGPoint.randomLocation(for: otherPlayer))
        powerupManager.applyPowerup(hideDrawingPowerup)
        XCTAssertFalse(selectedPlayer.canvasDrawing.isHidden, "Invulnerable player's drawing was hidden")
    }
}
