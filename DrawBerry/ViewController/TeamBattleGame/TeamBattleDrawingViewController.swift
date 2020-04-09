//
//  TeamBattleDrawingViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleDrawingViewController: CanvasDelegateViewController {

    var game: TeamBattleGame!
    var canvas: Canvas!
    var topicTextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCanvasToView()
        addDoneButtonToView()
        addTopicTextLabelToView()
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        canvas.isClearButtonEnabled = true
        canvas.isUndoButtonEnabled = true
        canvas.delegate = self
        self.view.addSubview(canvas)
        self.canvas = canvas
    }

    private func addTopicTextLabelToView() {
        let frame = CGRect(x: self.view.frame.midX - 150, y: 50, width: 300, height: 50)
        let topicTextLabel = UILabel(frame: frame)

        guard let topic = game.userTeam?.drawer.getDrawingTopic() else {
            return
        }
        topicTextLabel.text = "Round \(game.currentRound) Topic: \(topic)"
        topicTextLabel.textAlignment = .center
        topicTextLabel.font = UIFont(name: "Noteworthy", size: 30)
        self.topicTextLabel = topicTextLabel
        self.view.addSubview(topicTextLabel)
    }

    private func reloadTopicText() {
        guard let topic = game.userTeam?.drawer.getDrawingTopic() else {
            return
        }
        topicTextLabel.text = "Round \(game.currentRound) Topic: \(topic)"
    }

    private func addDoneButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 250,
                              width: 100, height: 50)
        button.backgroundColor = .systemYellow
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneOnTap(sender:)), for: .touchUpInside)

        self.view.addSubview(button)
    }

    @objc private func doneOnTap(sender: UIButton) {
        finishDrawing()
    }

    private func reloadCanvas() {
        canvas.removeFromSuperview()
        addCanvasToView()
        view.sendSubviewToBack(canvas)
    }

    private func finishDrawing() {
        game.addUsersDrawing(image: canvas.drawingImage)

        // TODO:
        if game.currentRound >= game.maxRounds {
            performSegue(withIdentifier: "drawToTeamBattleEnd", sender: self)
            return
        }

        // Proceed to next round
        game.incrementRound()
        reloadCanvas()
        reloadTopicText()
    }

}
