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
        cooperativeGame.waitForPreviousPlayerToFinish()
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        self.view.addSubview(canvasBackground)
    }

    private func displayMessage() {
        let message = UILabel(frame: self.view.frame)
        message.text = cooperativeGame.isFirstPlayer ? "You're up! Get Ready!" : "Stare at your friend."
        message.textAlignment = .center
        message.font = UIFont(name: "Noteworthy", size: 80)
        self.view.addSubview(message)
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
