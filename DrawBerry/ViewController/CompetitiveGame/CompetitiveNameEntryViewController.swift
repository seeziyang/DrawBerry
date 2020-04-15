//
//  CompetitiveNameEntryViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 13/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveNameEntryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    let player1DefaultName = "Player 1", player2DefaultName = "Player 2",
        player3DefaultName = "Player 3", player4DefaultName = "Player 4"
    var playerNames = [String]()

    @IBOutlet private var player1TextLabel: UITextField!
    @IBOutlet private var player2TextLabel: UITextField!
    @IBOutlet private var player3TextLabel: UITextField!
    @IBOutlet private var player4TextLabel: UITextField!
    @IBOutlet private var messageLabel: UILabel!

    @IBAction private func startGameButton(_ sender: Any) {
        guard let player1Text = player1TextLabel.text, let player2Text = player2TextLabel.text,
            let player3Text = player3TextLabel.text, let player4Text = player4TextLabel.text else {
                return
        }
        let player1Name = player1Text.isEmpty ? player1DefaultName : player1Text
        let player2Name = player2Text.isEmpty ? player2DefaultName : player2Text
        let player3Name = player3Text.isEmpty ? player3DefaultName : player3Text
        let player4Name = player4Text.isEmpty ? player4DefaultName : player4Text

        playerNames = [player1Name, player2Name, player3Name, player4Name]
        var playerSet = Set<String>()
        playerNames.forEach { playerSet.insert($0) }

        if playerSet.count != playerNames.count {
            messageLabel.isHidden = false
            messageLabel.text = "Duplicate names are not allowed!"
            return
        }

        performSegue(withIdentifier: "segueToCompetitiveGame", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let competitiveVC = segue.destination as? CompetitiveViewController {
            competitiveVC.playerNames = playerNames
        }
    }

    @IBAction private func goBackToLoginScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}
