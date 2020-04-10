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
        let text = "Waiting For Results"
        addTextLabelToView(text: text)
    }

    func updateResults() {

        guard game.gameResult.didGameFinish() else {
            return
        }

        guard let team = game.userTeam, let rank = game.gameResult.getRank(team: team) else {
            return
        }

        let scoreMessage = game.userTeam?.result.getDisplayDescription() ?? "Error"
        let rankMessage = "\n Your Rank: \(rank)"
        let message = scoreMessage + rankMessage
        changeDisplayMessage(text: message)

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

}
