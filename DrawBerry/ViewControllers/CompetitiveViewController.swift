//
//  CompetitiveViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

class CompetitiveViewController: UIViewController {
    private var competitiveView = CompetitiveView()
    private var competitiveGame = CompetitiveGame()

    private var powerupManager = PowerupManager() {
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

    private var timer: Timer?
    private var timeLeft = CompetitiveGame.TIME_PER_ROUND {
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

        powerupManager.rollForPowerup(for: competitiveGame.players)

        checkForPlayerStrokeOutOfBounds()
        checkNumberOfStrokesUsed()
        checkPowerupActivations()
    }

    /// Checks to see if each player's stroke is within their canvas bounds
    private func checkForPlayerStrokeOutOfBounds() {
        for player in competitiveGame.players {
            let playerCanvas = player.canvasDrawing
            guard let currentCoordinate = playerCanvas.currentCoordinate else {
                continue
            }

            if !playerCanvas.bounds.contains(currentCoordinate) {
                playerCanvas.isAbleToDraw = false
            }
        }
    }

    /// Checks to see if each player can continue drawing based on the number of strokes used.
    private func checkNumberOfStrokesUsed() {
        for player in competitiveGame.players {
            if player.canvasDrawing.numberOfStrokes >= CompetitiveGame.STROKES_PER_PLAYER + player.extraStrokes {
                // Player has used their stroke, disable their canvas
                player.canvasDrawing.isAbleToDraw = false
            } else {
                player.canvasDrawing.isAbleToDraw = true
            }
        }
    }

    /// Checks to see if any player has activated a powerup by drawing over it.
    private func checkPowerupActivations() {
        for player in competitiveGame.players {
            guard let currentCoordinates = player.canvasDrawing.currentCoordinate else {
                continue
            }

            let playerCoordinates = CGPoint(x: currentCoordinates.x + player.canvasDrawing.frame.origin.x,
                                            y: currentCoordinates.y + player.canvasDrawing.frame.origin.y)

            for powerup in powerupManager.allAvailablePowerups {
                let midPoint = CGPoint(x: powerup.location.x + PowerupManager.POWERUP_RADIUS,
                                       y: powerup.location.y + PowerupManager.POWERUP_RADIUS)

                let dx = midPoint.x - playerCoordinates.x
                let dy = midPoint.y - playerCoordinates.y
                let distance = sqrt(dx * dx + dy * dy)

                if distance <= PowerupManager.POWERUP_RADIUS {
                    powerupManager.applyPowerup(powerup)
                }
            }
        }
    }

    /// Adds the four players to the competitive game.
    private func setupPlayers() {
        for i in 1...4 {
            let newPlayer = Player(name: "Player \(i)", canvasDrawing: BerryCanvas())
            competitiveGame.players.append(newPlayer)
        }
    }

    // Maybe we should create a helper class to populate canvases in the view
    private func addCanvasesToView() {
        assert(competitiveGame.players.count == 4, "Player count should be 4")

        let defaultSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height / 2)

        let minX = self.view.bounds.minX
        let maxX = self.view.bounds.maxX
        let minY = self.view.bounds.minY
        let maxY = self.view.bounds.maxY

        var playerNum = 0
        for y in stride(from: minY, to: maxY, by: (maxY + minY) / 2) {
            for x in stride(from: minX, to: maxX, by: (maxX + minX) / 2) {
                let rect = CGRect(origin: CGPoint(x: x, y: y), size: defaultSize)
                guard let canvas = createBerryCanvas(within: rect) else {
                    return
                }
                competitiveGame.players[playerNum].canvasDrawing = canvas
                self.view.addSubview(canvas)
                playerNum += 1
            }
        }
    }

    private func createBerryCanvas(within rect: CGRect) -> Canvas? {
        guard let canvas = BerryCanvas.createCanvas(within: rect) else {
            return nil
        }
        canvas.isClearButtonEnabled = false
        canvas.isUndoButtonEnabled = false
        canvas.delegate = self

        return canvas
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
        for player in competitiveGame.players {
            player.canvasDrawing.isAbleToDraw = false
        }
    }

    private func setupDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: .common)
    }
}

extension CompetitiveViewController: CanvasDelegate {
    func handleDraw(recognizer: UIPanGestureRecognizer, canvas: Canvas) {
        if !canvas.isAbleToDraw {
            recognizer.state = .ended
            recognizer.isEnabled = false
            return
        }
        if recognizer.state == .ended {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.syncHistory(on: canvas)
            }
        }
    }

    func syncHistory(on canvas: Canvas) {
        let prevSize = canvas.history.last?.dataRepresentation().count ?? PKDrawing().dataRepresentation().count
        if prevSize < canvas.drawing.dataRepresentation().count {
            // A stroke was added
            updateHistory(on: canvas, with: canvas.drawing)
            canvas.numberOfStrokes += 1
            return
        }
        if prevSize > canvas.drawing.dataRepresentation().count {
            // A stroke was deleted
            updateHistory(on: canvas, with: canvas.drawing)
            canvas.numberOfStrokes -= 1
            return
        }
    }

    func updateHistory(on canvas: Canvas, with drawing: PKDrawing) {
        canvas.history.append(drawing)
    }

    /// Undo the drawing to the previous state one stroke before.
    func undo(on canvas: Canvas) -> PKDrawing {
        if canvas.history.isEmpty {
            return PKDrawing()
        }
        _ = canvas.history.popLast()
        canvas.numberOfStrokes -= 1
        guard let lastDrawing = canvas.history.last else {
            return PKDrawing()
        }
        return lastDrawing
    }

    func clear(canvas: Canvas) {
        updateHistory(on: canvas, with: PKDrawing())
        canvas.numberOfStrokes = 0
    }
}
