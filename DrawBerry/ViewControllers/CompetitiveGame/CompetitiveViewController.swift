//
//  CompetitiveViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 14/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveViewController: CanvasDelegateViewController {
    private var competitiveViews: [CompetitivePlayer: CompetitiveView] = [:]
    var competitiveGame = CompetitiveGame()

    private var powerupManager = PowerupManager() {
        didSet {
            if !powerupManager.powerupsToAdd.isEmpty {
                powerupManager.powerupsToAdd.forEach { competitiveViews[$0.owner]?.addPowerupToView($0) }
                powerupManager.powerupsToAdd.removeAll()
            }

            if !powerupManager.powerupsToRemove.isEmpty {
                powerupManager.powerupsToRemove.forEach { competitiveViews[$0.owner]?.removePowerupFromView($0) }
                powerupManager.powerupsToRemove.removeAll()
            }
        }
    }

    private var timer: Timer?
    private var timeLeft = CompetitiveGame.TIME_PER_ROUND {
        didSet {
            competitiveViews.values.forEach { $0.updateTimeLeftText(to: String(timeLeft)) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayers()
        addCanvasesToView()
        setupTimer()
        setupDisplayLink()
    }

    @objc func update() {
        if timeLeft <= 0 {
            return
        }

        if timeLeft <= CompetitiveGame.TIME_PER_ROUND - CompetitiveGame.TIME_AFTER_POWERUPS_SPAWN &&
            timeLeft >= CompetitiveGame.MIN_TIME_POWERUPS_SPAWN {
            powerupManager.rollForPowerup(for: competitiveGame.players)
        }

        checkForPlayersDoneWithDrawing()
        checkForPlayerStrokeOutOfBounds()
        checkNumberOfStrokesUsed()
        checkPowerupActivations()
    }

    /// Checks to see if all players are done with drawing
    private func checkForPlayersDoneWithDrawing() {
        for player in competitiveGame.players where
            player.canvasDrawing.numberOfStrokes < CompetitiveGame.STROKES_PER_PLAYER + player.extraStrokes {
                return
        }

        timeLeft = min(timeLeft, 3)
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

            for powerup in powerupManager.allAvailablePowerups {
                let midPoint = CGPoint(x: powerup.location.x + PowerupManager.POWERUP_RADIUS,
                                       y: powerup.location.y + PowerupManager.POWERUP_RADIUS)

                let dx = midPoint.x - currentCoordinates.x
                let dy = midPoint.y - currentCoordinates.y
                let distance = sqrt(dx * dx + dy * dy)

                if distance <= PowerupManager.POWERUP_RADIUS && player == powerup.owner {
                    powerupManager.applyPowerup(powerup)
                    drawDescriptionOnView(powerup)
                }
            }
        }
    }

    /// Draws the specified powerup description on the powerup's targets.
    private func drawDescriptionOnView(_ powerup: Powerup) {
        for target in powerup.targets {
            if powerup.owner != target && target.isInvulnerable {
                let newDescription = powerup.description + "\n" + Message.playerIsInvulnerable
                competitiveViews[target]?.animateStatus(with: newDescription)
            } else {
                competitiveViews[target]?.animateStatus(with: powerup.description)
            }
        }
    }

    /// Adds the four players to the competitive game.
    private func setupPlayers() {
        if !competitiveGame.players.isEmpty {
            return
        }

        for i in 1...4 {
            let newPlayer = CompetitivePlayer(name: "Player \(i)", canvasDrawing: BerryCanvas())
            competitiveGame.players.append(newPlayer)
        }
    }

    /// Adds the canvases for the four players to the competitive game.
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

                let currentPlayer = competitiveGame.players[playerNum]
                currentPlayer.canvasDrawing = canvas

                let currentPlayerCompetitiveView = CompetitiveView(frame: rect)
                competitiveViews[currentPlayer] = currentPlayerCompetitiveView
                currentPlayerCompetitiveView.isUserInteractionEnabled = false
                currentPlayerCompetitiveView.setupViews(name: competitiveGame.players[playerNum].name,
                                                        currentRound: competitiveGame.currentRound,
                                                        maxRounds: CompetitiveGame.MAX_ROUNDS,
                                                        score: competitiveGame.players[playerNum].score)

                if playerNum < 2 {
                    canvas.transform = canvas.transform.rotated(by: CGFloat.pi)
                    currentPlayerCompetitiveView.transform =
                        currentPlayerCompetitiveView.transform.rotated(by: CGFloat.pi)
                }

                self.view.addSubview(canvas)
                self.view.addSubview(currentPlayerCompetitiveView)

                playerNum += 1
            }
        }
    }

    /// Creates a canvas within the specified `CGRect`.
    private func createBerryCanvas(within rect: CGRect) -> Canvas? {
        guard let canvas = BerryCanvas.createCanvas(within: rect) else {
            return nil
        }
        canvas.isClearButtonEnabled = false
        canvas.isUndoButtonEnabled = false
        canvas.isEraserEnabled = false
        canvas.delegate = self

        return canvas
    }

    /// Sets up the timer for the game which fires every 1 second.
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }

    @objc func onTimerFires() {
        timeLeft -= 1

        if timeLeft <= 0 {
            disableAllPlayerDrawings()
            showNextButtons()

            timer?.invalidate()
            timer = nil
        }
    }

    /// Shows the next buttons on players' views.
    private func showNextButtons() {
        for view in competitiveViews.values {
            let nextButtonImageView = UIImageView(image: CompetitiveGame.NEXT_BUTTON)

            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapNextButton(_:)))
            nextButtonImageView.addGestureRecognizer(tap)
            nextButtonImageView.isUserInteractionEnabled = true

            view.addNextButton(nextButtonImageView)
            view.isUserInteractionEnabled = true
        }
    }

    var playersReady = 0
    @objc func handleTapNextButton(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        playersReady += 1

        if playersReady == competitiveGame.players.count {
            segueToCompetitiveVoting()
        }
    }

    private func segueToCompetitiveVoting() {
        performSegue(withIdentifier: "segueToCompetitiveVoting", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let votingVC = segue.destination as? CompetitiveVotingViewController {
            votingVC.drawingList = competitiveGame.players.map { $0.canvasDrawing.drawingImage }
            votingVC.currentGame = competitiveGame
        }
    }

    /// Disables the canvas for all players.
    private func disableAllPlayerDrawings() {
        for player in competitiveGame.players {
            player.canvasDrawing.isAbleToDraw = false
        }
    }

    /// Sets up the display link for the game.
    private func setupDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: .common)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}
