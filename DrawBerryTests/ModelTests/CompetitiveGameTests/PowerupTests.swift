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
                                         location: CGPoint.randomLocationInCanvas(for: selectedPlayer))
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
                                         location: CGPoint.randomLocationInCanvas(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            XCTAssertEqual(player.extraStrokes, 0, "Other player's extra stroke was changed")
        }

        XCTAssertEqual(selectedPlayer.extraStrokes, 1, "Selected player's extra stroke was not incremented")
    }

    func testInkSplotchPowerup() {
        let selectedPlayer = players[2]
        let powerup = InkSplotchPowerup(owner: selectedPlayer, players: players,
                                        location: CGPoint.randomLocationInCanvas(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            XCTAssertEqual(player.canvasDrawing.subviews.count,
                           selectedPlayer.canvasDrawing.subviews.count + 1, "Ink splotch was not added to targets")
        }
    }

    func testInvulnerabilityPowerup() {
        let selectedPlayer = players[3]
        let powerup = InvulnerabilityPowerup(owner: selectedPlayer, players: players,
                                             location: CGPoint.randomLocationInCanvas(for: selectedPlayer))
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

    func testEarthquakePowerup() {
        let selectedPlayer = players[1]
        let powerup = EarthquakePowerup(owner: selectedPlayer, players: players,
                                        location: CGPoint.randomLocationInCanvas(for: selectedPlayer))
        powerupManager.applyPowerup(powerup)

        for player in players where player != selectedPlayer {
            let rotationAngle = atan2(player.canvasDrawing.transform.b, player.canvasDrawing.transform.a)
            XCTAssertNotEqual(rotationAngle, player.canvasDrawing.defaultRotationValue,
                              "Target player's canvas was not rotated")
        }

        let rotationAngle = atan2(selectedPlayer.canvasDrawing.transform.b, selectedPlayer.canvasDrawing.transform.a)
        XCTAssertEqual(rotationAngle, selectedPlayer.canvasDrawing.defaultRotationValue,
                       "Owner's canvas was rotated")
    }

    func testHideDrawingWhileInvulnerable() {
        let invulnerablePlayer = players[0]
        let otherPlayer = players[1]
        let invulnerabilityPowerup =
            InvulnerabilityPowerup(owner: invulnerablePlayer, players: players,
                                   location: CGPoint.randomLocationInCanvas(for: invulnerablePlayer))
        powerupManager.applyPowerup(invulnerabilityPowerup)

        let hideDrawingPowerup = HideDrawingPowerup(owner: otherPlayer, players: players,
                                                    location: CGPoint.randomLocationInCanvas(for: otherPlayer))
        powerupManager.applyPowerup(hideDrawingPowerup)
        XCTAssertFalse(invulnerablePlayer.getInnermostCanvas().isHidden, "Invulnerable player's drawing was hidden")
    }

    func testEarthquakeWhileInvulnerable() {
        let invulnerablePlayer = players[3]
        let otherPlayer = players[0]
        let invulnerabilityPowerup =
            InvulnerabilityPowerup(owner: invulnerablePlayer, players: players,
                                   location: CGPoint.randomLocationInCanvas(for: invulnerablePlayer))
        powerupManager.applyPowerup(invulnerabilityPowerup)

        let earthquakePowerup = EarthquakePowerup(owner: otherPlayer, players: players,
                                                  location: CGPoint.randomLocationInCanvas(for: otherPlayer))
        powerupManager.applyPowerup(earthquakePowerup)
        let rotationAngle = atan2(invulnerablePlayer.canvasDrawing.transform.b,
                                  invulnerablePlayer.canvasDrawing.transform.a)

        XCTAssertEqual(rotationAngle, invulnerablePlayer.getInnermostCanvas().defaultRotationValue,
                       accuracy: 1e-6, "Invulnerable player's canvas was rotated")
    }

    func testInkSplotchWhileInvulnerable() {
        let invulnerablePlayer = players[2]
        let otherPlayer = players[0]

        let expectedNumberOfSubviews = invulnerablePlayer.canvasDrawing.subviews.count
        let invulnerabilityPowerup =
            InvulnerabilityPowerup(owner: invulnerablePlayer, players: players,
                                   location: CGPoint.randomLocationInCanvas(for: invulnerablePlayer))
        powerupManager.applyPowerup(invulnerabilityPowerup)

        let inkSplotchPowerup = InkSplotchPowerup(owner: otherPlayer, players: players,
                                                  location: CGPoint.randomLocationInCanvas(for: otherPlayer))
        powerupManager.applyPowerup(inkSplotchPowerup)

        XCTAssertEqual(expectedNumberOfSubviews, invulnerablePlayer.getInnermostCanvas().subviews.count,
                       "Subview count differs for invulnerable player")
    }

    func testExtraStrokeWhileInvulnerable() {
        let invulnerablePlayer = players[1]
        let invulnerabilityPowerup =
            InvulnerabilityPowerup(owner: invulnerablePlayer, players: players,
                                   location: CGPoint.randomLocationInCanvas(for: invulnerablePlayer))
        powerupManager.applyPowerup(invulnerabilityPowerup)

        let extraStrokePowerup = ExtraStrokePowerup(owner: invulnerablePlayer, players: players,
                                                    location: CGPoint.randomLocationInCanvas(for: invulnerablePlayer))
        powerupManager.applyPowerup(extraStrokePowerup)

        XCTAssertEqual(invulnerablePlayer.extraStrokes, 1, "Extra stroke not incremented for invulnerable player")
    }
}

extension CompetitivePlayer {
    func getInnermostCanvas() -> CompetitiveCanvas {
        var currentCanvas = canvasDrawing
        while true {
            guard let canvas = currentCanvas.decoratedCanvas else {
                return currentCanvas
            }
            currentCanvas = canvas
        }
    }
}
