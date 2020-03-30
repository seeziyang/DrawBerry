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

    private func startGame() {
        if cooperativeGame.isFirstPlayer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.navigateToDrawingPage()
            }
            return
        }
        cooperativeGame.waitForPreviousPlayersToFinish()
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        view.addSubview(canvasBackground)
    }

    func changeMessageToGetReady() {
        messageLabel.text = Message.getReadyMessage
    }

    private func displayMessage() {
        let message = UILabel(frame: self.view.frame)
        message.text = cooperativeGame.isFirstPlayer ? Message.getReadyMessage : Message.waitingMessage
        message.textAlignment = .center
        message.font = UIFont(name: "Noteworthy", size: 80)
        messageLabel = message
        view.addSubview(message)
    }

    func navigateToDrawingPage() {
        performSegue(withIdentifier: "segueToDrawing", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let drawingVC = segue.destination as? DrawingViewController {
            drawingVC.cooperativeGame = cooperativeGame
        }
    }

}
