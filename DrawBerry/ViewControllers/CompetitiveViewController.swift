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
    var game = CompetitiveGame()
    var timer: Timer?
    var timeLeft = CompetitiveGame.TIME_PER_ROUND
    var timeLeftLabel = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupPlayers()
        addCanvasesToView()
        addTimeLeftText()
        setupTimer()
        setupDisplayLink()
    }

    // Just a small function to show the time left for testing purposes.
    // Will probably remove/refactor this as gameplay is further developed.
    private func addTimeLeftText() {
        let resultWidth = 200, resultHeight = 200, resultSize = 120, resultFont = "MarkerFelt-Thin"

        timeLeftLabel = UITextView(
            frame: CGRect(x: self.view.bounds.midX - CGFloat(resultWidth / 2),
                          y: self.view.bounds.midY - CGFloat(resultHeight / 2),
                          width: CGFloat(resultWidth),
                          height: CGFloat(resultHeight)),
            textContainer: nil)
        timeLeftLabel.font = UIFont(name: resultFont, size: CGFloat(resultSize))
        timeLeftLabel.textAlignment = NSTextAlignment.center
        timeLeftLabel.text = String(timeLeft)
        timeLeftLabel.backgroundColor = UIColor.clear
        timeLeftLabel.isUserInteractionEnabled = false

        self.view.addSubview(timeLeftLabel)
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

        game.rollForPowerups()
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
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let topLeftCanvas: Canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        topLeftCanvas.isClearButtonEnabled = false
        topLeftCanvas.isUndoButtonEnabled = false
        topLeftCanvas.delegate = self
        game.players[0].canvasDrawing = topLeftCanvas
        self.view.addSubview(topLeftCanvas)

        let topRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.minY)
        let topRightRect = CGRect(origin: topRightOrigin, size: defaultSize)
        guard let topRightCanvas: Canvas = BerryCanvas.createCanvas(within: topRightRect) else {
            return
        }
        topRightCanvas.isClearButtonEnabled = false
        topRightCanvas.isUndoButtonEnabled = false
        topRightCanvas.delegate = self
        game.players[1].canvasDrawing = topRightCanvas
        self.view.addSubview(topRightCanvas)

        let bottomLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.midY)
        let bottomLeftRect = CGRect(origin: bottomLeftOrigin, size: defaultSize)
        guard let bottomLeftCanvas: Canvas = BerryCanvas.createCanvas(within: bottomLeftRect) else {
            return
        }
        bottomLeftCanvas.isClearButtonEnabled = false
        bottomLeftCanvas.isUndoButtonEnabled = false
        bottomLeftCanvas.delegate = self
        game.players[2].canvasDrawing = bottomLeftCanvas
        self.view.addSubview(bottomLeftCanvas)

        let bottomRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        let bottomRightRect = CGRect(origin: bottomRightOrigin, size: defaultSize)
        guard let bottomRightCanvas: Canvas = BerryCanvas.createCanvas(within: bottomRightRect) else {
            return
        }
        bottomRightCanvas.isClearButtonEnabled = false
        bottomRightCanvas.isUndoButtonEnabled = false
        bottomRightCanvas.delegate = self
        game.players[3].canvasDrawing = bottomRightCanvas
        self.view.addSubview(bottomRightCanvas)
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }

    @objc func onTimerFires() {
        timeLeft -= 1

        timeLeftLabel.text = String(timeLeft)
        timeLeftLabel.setNeedsDisplay()

        if timeLeft <= 0 {
            disableAllPlayerDrawings()
            timer?.invalidate()
            timer = nil
        }
    }

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
