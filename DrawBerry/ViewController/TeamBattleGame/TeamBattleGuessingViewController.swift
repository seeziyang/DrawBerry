//
//  TeamBattleGuessingViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleGuessingViewController: UIViewController, TeamBattleGameViewDelegate {

    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var userInputTextField: UITextField!
    @IBOutlet private weak var guessBox: UIView!

    var game: TeamBattleGame!
    var messageLabel: UILabel!
    var imageView: UIImageView!
    var currentRound = 1

    var isGuesserWaiting: Bool = true {
        didSet {
            if currentRound == game.maxRounds {
                return
            }

            if isGuesserWaiting {
                imageView.image = nil
                guessBox.alpha = 0
                let text = "Round \(currentRound + 1)\n\(Message.teamBattleWaitingMessage)"
                displayMessage(text: text)
            } else {
                let drawingIndex = currentRound - 1
                imageView.image = game.userTeam?.drawings[drawingIndex]
                changeMessage(text: "")
                guessBox.alpha = 1

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.alpha = 0
        addCanvasToView()
        addImageToView()
        let text = "Round \(currentRound)\n\(Message.teamBattleWaitingMessage)"
        displayMessage(text: text)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let teamBattleEndVC = segue.destination as? TeamBattleEndViewController {

            guard let result = game.userTeam?.result else {
                return
            }
            game.addTeamResult(result: result)
            teamBattleEndVC.game = game
            teamBattleEndVC.game.resultDelegate = teamBattleEndVC
            teamBattleEndVC.game.observeAllTeamResult()
        }
    }

    @IBAction private func guessCurrentDrawing(_ sender: UIButton) {
        guard let guess = StringHelper.trim(string: userInputTextField.text) else {
            return
        }
        userInputTextField.text = ""

        guard let team = game.userTeam else {
            return
        }

        guard team.guesser.isGuessCorrect(guess: guess, for: currentRound) else {
            team.result.addincorrectGuess()
            showErrorMessage("Guess is wrong!")
            return
        }

        //goToNextDrawing
        if !viewNextDrawing() {
            isGuesserWaiting = true
        }
        team.result.addCorrectGuess()
        proceedToNextRound()

    }

    func proceedToNextRound() {
        currentRound += 1
        if currentRound > game.maxRounds {
            performSegue(withIdentifier: "guessToTeamBattleEnd", sender: self)
        }
    }

    func nextDrawingReady() -> Bool {
        let nextDrawingIndex = currentRound

        guard let drawings = game.userTeam?.drawings else {
            return false
        }

        return drawings.count > nextDrawingIndex
    }

    private func viewNextDrawing() -> Bool {
        let nextDrawingIndex = currentRound
        if nextDrawingReady() {
            changeMessage(text: "")
            guessBox.alpha = 1
            imageView.image = game.userTeam?.drawings[nextDrawingIndex]
            return true
        }
        return false
    }

    @IBAction private func goToNextDrawing(_ sender: UIButton) {
        guard viewNextDrawing() else {
            showErrorMessage("Drawing is not ready!")
            return
        }
        proceedToNextRound()
    }

    func updateDrawing(_ image: UIImage, for round: Int) {
        game.userTeam?.drawings.append(image)

        // loads image if user is waiting on the round
        if isGuesserWaiting && round >= currentRound {
            isGuesserWaiting = false
        }
    }

    /// Adds the background canvas.
    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 200)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        view.addSubview(canvasBackground)
    }

    private func addImageToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 200)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        self.imageView = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        imageView.image = nil
        view.addSubview(imageView)
    }

    private func showErrorMessage(_ text: String) {
        errorMessageLabel.text = text
        errorMessageLabel.alpha = 1
    }

    func changeMessage(text: String) {
        messageLabel.text = text
    }

    /// Display a message for the player.
    private func displayMessage(text: String) {
        let message = UILabel(frame: self.view.frame)
        message.text = text
        message.textAlignment = .center
        message.font = UIFont(name: "Noteworthy", size: 80)
        message.numberOfLines = 2
        messageLabel = message
        view.addSubview(message)
    }

}
