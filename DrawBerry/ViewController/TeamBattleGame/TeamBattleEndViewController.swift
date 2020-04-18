//
//  TeamBattleEndViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleEndViewController: UIViewController, TeamBattleResultDelegate {

    var game: TeamBattleGame!
    var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCanvasToView()
        addTextLabelToView(text: Message.teamBattleWaitingResult)
    }

    /// Updates game result whenever a new team result is downloaded from database
    func updateResults() {
        guard game.gameResult.didGameFinish() else {
            return
        }

        guard let team = game.userTeam, let rank = game.gameResult.getRank(team: team) else {
            return
        }

        let scoreMessage = game.userTeam?.result.getDisplayDescription()
            ?? Message.teamBattleResultError
        let rankMessage = "\n Your Rank: \(rank)"
        let message = scoreMessage + rankMessage
        changeDisplayMessage(text: message)
        addMenuButtonToView()
    }

    /// Adds the background canvas.
    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = Constants.background
        view.addSubview(canvasBackground)
    }

    private func changeDisplayMessage(text: String) {
        messageLabel.text = text
    }

    /// Display a message for the player.
    private func addTextLabelToView(text: String) {
        let message = UILabel(frame: self.view.frame)
        message.text = text
        message.textAlignment = .center
        message.font = UIFont(name: "Noteworthy", size: 60)
        message.numberOfLines = 8
        messageLabel = message
        view.addSubview(message)
    }

    /// Adds the button to return to the main menu.
    private func addMenuButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 70, y: self.view.frame.maxY - 220,
                              width: 150, height: 50)
        button.backgroundColor = .systemYellow
        button.setTitle("Main Menu", for: .normal)
        button.addTarget(self, action: #selector(backToMenu(sender:)), for: .touchUpInside)

        view.addSubview(button)
    }

    @objc private func backToMenu(sender: UIButton) {
        performSegue(withIdentifier: "teamBattleEndToMenu", sender: self)
        game.endGame()
    }

}
