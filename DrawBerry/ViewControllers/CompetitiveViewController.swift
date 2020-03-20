//
//  CompetitiveViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

class CompetitiveViewController: CanvasDelegateViewController {
    var game = CompetitiveGame()
    var powerupManager = PowerupManager() {
        didSet {
            if !powerupManager.powerupsToAdd.isEmpty {
                competitiveView.addPowerupsToView(powerupManager.powerupsToAdd)
                powerupManager.powerupsToAdd.removeAll()
            }

            if !powerupManager.powerupsToRemove.isEmpty {
                competitiveView.removePowerupsFromView(powerupManager.powerupsToRemove)
                powerupManager.powerupsToRemove.removeAll()
            }
        }
    }

    var timer: Timer?

    var competitiveView = CompetitiveView()
    var timeLeft = CompetitiveGame.TIME_PER_ROUND {
        didSet {
            competitiveView.updateTimeLeftText(to: String(timeLeft))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayers()
        addCanvasesToView()
        setupViews()
        setupTimer()
        setupDisplayLink()
    }

    private func setupViews() {
        competitiveView.frame = CGRect(x: 0, y: 0,
                                       width: view.bounds.maxX - view.bounds.minX,
                                       height: view.bounds.maxY - view.bounds.minY)
        competitiveView.isUserInteractionEnabled = false
        self.view.addSubview(competitiveView)
        competitiveView.setupViews()
    }

    @objc func update() {
        if timeLeft <= 0 {
            return
        }

        powerupManager.rollForPowerup(for: game.players)

        checkNumberOfStrokesUsed()
        checkPowerupActivations()
    }

    private func checkNumberOfStrokesUsed() {
        for player in game.players {
            if player.canvasDrawing.numberOfStrokes >= CompetitiveGame.STROKES_PER_PLAYER + player.extraStrokes {
                // Player has used their stroke, disable their canvas
                player.canvasDrawing.isAbleToDraw = false
            } else {
                player.canvasDrawing.isAbleToDraw = true
            }
        }
    }

    private func checkPowerupActivations() {
        for player in game.players {
            guard let currentCoordinates = player.canvasDrawing.currentCoordinate else {
                continue
            }

            let playerCoordinates = CGPoint(x: currentCoordinates.x + player.canvasDrawing.frame.origin.x,
                                            y: currentCoordinates.y + player.canvasDrawing.frame.origin.y)

            for powerup in powerupManager.allAvailablePowerups {
                let midPoint = CGPoint(x: powerup.location.x + CGFloat(PowerupManager.POWERUP_RADIUS),
                                       y: powerup.location.y + CGFloat(PowerupManager.POWERUP_RADIUS))

                let dx = midPoint.x - playerCoordinates.x
                let dy = midPoint.y - playerCoordinates.y
                let distance = sqrt(dx * dx + dy * dy)

                if distance <= CGFloat(PowerupManager.POWERUP_RADIUS) {
                    powerupManager.applyPowerup(powerup)
                }
            }
        }
    }

    /// Adds the four players to the competitive game.
    private func setupPlayers() {
        for i in 1...4 {
            let newPlayer = CompetitivePlayer(name: "Player \(i)", canvasDrawing: BerryCanvas())
            game.players.append(newPlayer)
        }
    }

    // Maybe we should create a helper class to populate canvases in the view
    private func addCanvasesToView() {
        assert(game.players.count == 4, "Player count should be 4")

        let defaultSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height / 2)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        guard let topLeftCanvas = createCompetitiveCanvas(at: topLeftOrigin, size: defaultSize) else {
            return
        }
        game.players[0].canvasDrawing = topLeftCanvas
        self.view.addSubview(topLeftCanvas)

        let topRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.minY)
        guard let topRightCanvas = createCompetitiveCanvas(at: topRightOrigin, size: defaultSize) else {
            return
        }
        game.players[1].canvasDrawing = topRightCanvas
        self.view.addSubview(topRightCanvas)

        let bottomLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.midY)
        guard let bottomLeftCanvas = createCompetitiveCanvas(at: bottomLeftOrigin, size: defaultSize) else {
            return
        }
        game.players[2].canvasDrawing = bottomLeftCanvas
        self.view.addSubview(bottomLeftCanvas)

        let bottomRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        guard let bottomRightCanvas = createCompetitiveCanvas(at: bottomRightOrigin, size: defaultSize) else {
            return
        }
        game.players[3].canvasDrawing = bottomRightCanvas
        self.view.addSubview(bottomRightCanvas)
    }

    private func createCompetitiveCanvas(at point: CGPoint, size: CGSize) -> Canvas? {
        let canvasOrigin = point
        let rect = CGRect(origin: canvasOrigin, size: size)
        guard let newCanvas: Canvas = BerryCanvas.createCanvas(within: rect) else {
            return nil
        }
        newCanvas.isClearButtonEnabled = false
        newCanvas.isUndoButtonEnabled = false
        newCanvas.delegate = self
        return newCanvas
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }

    @objc func onTimerFires() {
        timeLeft -= 1

        if timeLeft <= 0 {
            disableAllPlayerDrawings()
            timer?.invalidate()
            timer = nil
        }
    }

    /// DIsables the canvas for all players
    private func disableAllPlayerDrawings() {
        for player in game.players {
            player.canvasDrawing.isAbleToDraw = false
        }
    }

    private func setupDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: .common)
    }
}
