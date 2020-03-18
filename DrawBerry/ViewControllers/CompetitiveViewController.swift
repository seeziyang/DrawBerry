//
//  CompetitiveViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveViewController: UIViewController {
    var game = CompetitiveGame()
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
        self.view.addSubview(competitiveView)
        competitiveView.setupViews()
    }

    @objc func update() {
        if timeLeft <= 0 {
            return
        }

        for player in game.players {
            if player.canvasDrawing.numberOfStrokes >= CompetitiveGame.STROKES_PER_PLAYER + player.extraStrokes {
                // Player has used their stroke, disable their canvas
                player.canvasDrawing.isAbleToDraw = false
            } else {
                player.canvasDrawing.isAbleToDraw = true
            }
        }

        // Get powerups and redraw
        game.rollForPowerups()
        let powerups = game.powerupManager.powerupsToAdd
        competitiveView.addPowerups(powerups)
    }

    /// Adds the four players to the competitive game.
    private func setupPlayers() {
        for i in 1...4 {
            let newPlayer = Player(name: "Player \(i)", canvasDrawing: BerryCanvas())
            game.players.append(newPlayer)
        }
    }

    private func addCanvasesToView() {
        assert(game.players.count == 4, "Player count should be 4")

        let defaultSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height / 2)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let topLeftCanvas: Canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        topLeftCanvas.isClearButtonEnabled = false
        game.players[0].canvasDrawing = topLeftCanvas
        self.view.addSubview(topLeftCanvas)

        let topRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.minY)
        let topRightRect = CGRect(origin: topRightOrigin, size: defaultSize)
        guard let topRightCanvas: Canvas = BerryCanvas.createCanvas(within: topRightRect) else {
            return
        }
        topRightCanvas.isClearButtonEnabled = false
        game.players[1].canvasDrawing = topRightCanvas
        self.view.addSubview(topRightCanvas)

        let bottomLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.midY)
        let bottomLeftRect = CGRect(origin: bottomLeftOrigin, size: defaultSize)
        guard let bottomLeftCanvas: Canvas = BerryCanvas.createCanvas(within: bottomLeftRect) else {
            return
        }
        bottomLeftCanvas.isClearButtonEnabled = false
        game.players[2].canvasDrawing = bottomLeftCanvas
        self.view.addSubview(bottomLeftCanvas)

        let bottomRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        let bottomRightRect = CGRect(origin: bottomRightOrigin, size: defaultSize)
        guard let bottomRightCanvas: Canvas = BerryCanvas.createCanvas(within: bottomRightRect) else {
            return
        }
        bottomRightCanvas.isClearButtonEnabled = false
        game.players[3].canvasDrawing = bottomRightCanvas
        self.view.addSubview(bottomRightCanvas)
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
