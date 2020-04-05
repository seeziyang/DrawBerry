//
//  WaitingViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 25/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class WaitingViewController: UIViewController, CooperativeGameDelegate {
    var cooperativeGame: CooperativeGame!
    var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCanvasToView()
        displayMessage()
        startGame()
    }

    /// Initialise the game and navigate to drawing canvas when user turn is reached.
    private func startGame() {
        if cooperativeGame.isFirstPlayer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.navigateToDrawingPage()
            }
            return
        }
        cooperativeGame.downloadPreviousDrawings()
    }

    /// Adds the background canvas.
    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        view.addSubview(canvasBackground)
    }

    /// Displays the ready message when the user's turn is about to begin.
    func changeMessageToGetReady() {
        messageLabel.text = Message.getReadyMessage
    }

    /// Display message according to the user's turn.
    private func displayMessage() {
        let message = UILabel(frame: self.view.frame)
        message.text = cooperativeGame.isFirstPlayer ? Message.getReadyMessage : Message.waitingMessage
        message.textAlignment = .center
        message.font = UIFont(name: "Noteworthy", size: 80)
        messageLabel = message
        view.addSubview(message)
    }

    /// Navigates to the drawing page when it is the user's turn.
    func navigateToDrawingPage() {
        performSegue(withIdentifier: "segueToDrawing", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let drawingVC = segue.destination as? DrawingViewController {
            drawingVC.cooperativeGame = cooperativeGame
        }
    }

}
