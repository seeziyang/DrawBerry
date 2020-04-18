//
//  ClassicViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 10/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

class ClassicViewController: CanvasDelegateViewController {
    var classicGame: ClassicGame!
    var canvas: Canvas!
    var timerBarView: TimerBarView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCanvasToView()
        addDoneButtonToView()
        addTopicToView()

        if !(classicGame is NonRapidClassicGame) {
            addTimerBarToView()
            timerBarView?.start()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let votingVC = segue.destination as? VotingViewController {
            votingVC.classicGame = classicGame
            votingVC.classicGame.delegate = votingVC
            votingVC.classicGame.observePlayersDrawing()
        }
    }

    private func addCanvasToView() {
        let size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 10)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: size)
        guard let canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        canvas.isClearButtonEnabled = true
        canvas.isUndoButtonEnabled = true
        canvas.delegate = self
        self.view.addSubview(canvas)
        self.canvas = canvas
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

    private func addTimerBarToView() {
        let timerBarView = TimerBarView(frame: CGRect(x: view.frame.minX, y: view.frame.maxY - 10,
                                                      width: view.frame.width, height: 10),
                                        duration: ClassicGame.drawingDuration,
                                        completionHandler: finishDrawing)
        view.addSubview(timerBarView)
        self.timerBarView = timerBarView
    }

    private func addTopicToView() {
        let label = UILabel(frame: CGRect(x: view.frame.minX, y: view.frame.minY + 30,
                                          width: view.frame.width, height: 150))
        label.text = "Round \(classicGame.currentRound): \(classicGame.getCurrentRoundTopic())"
        label.textAlignment = .center
        label.font = UIFont(name: "Noteworthy", size: 30)

        self.view.addSubview(label)
    }

    @objc private func doneOnTap(sender: UIButton) {
        timerBarView?.stop()
        finishDrawing()
    }

    private func finishDrawing() {
        classicGame.addUsersDrawing(image: canvas.drawingImage)

        if classicGame is NonRapidClassicGame && classicGame.userIsNextRoundMaster() {
            classicGame.addNextRoundTopic("my topic!!") // todo prompt user for this
        }

        segueToNextScreen()
    }

    private func segueToNextScreen() {
        if classicGame is NonRapidClassicGame {
            performSegue(withIdentifier: "classicUnwindSegueToHomeVC", sender: self)
        } else {
            performSegue(withIdentifier: "segueToVoting", sender: self)
        }
    }
}
