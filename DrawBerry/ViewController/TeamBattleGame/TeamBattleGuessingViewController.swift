//
//  TeamBattleGuessingViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleGuessingViewController: UIViewController, TeamBattleGameDelegate {

    var game: TeamBattleGame!
    var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCanvasToView()
        displayMessage(text: Message.teamBattleWaitingMessage)

    }

    func updateDrawing(_ image: UIImage) {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let imageView = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        imageView.image = image
        view.addSubview(imageView)
        changeMessage(text: "")
    }

    /// Adds the background canvas.
    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 100)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        view.addSubview(canvasBackground)
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
        messageLabel = message
        view.addSubview(message)
    }

}
