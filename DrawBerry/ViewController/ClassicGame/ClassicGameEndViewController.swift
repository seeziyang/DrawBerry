//
//  ClassicGameEndViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 1/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGameEndViewController: UIViewController {
    var classicGame: ClassicGame!

    @IBOutlet private weak var resultsText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonToView()
        setResultsText()
    }

    private func setResultsText() {
        var text = ""
        for player in classicGame.players {
            text += player.name.padding(toLength: 25, withPad: " ", startingAt: 0)
            text += String(player.points) + "\n"
        }
        resultsText.text = text
    }

    private func addDoneButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.midY + 150,
                              width: 100, height: 50)
        button.backgroundColor = .systemYellow
        button.setTitle("Ok", for: .normal)
        button.addTarget(self, action: #selector(okOnTap(sender:)), for: .touchUpInside)

        self.view.addSubview(button)
    }

    @objc private func okOnTap(sender: UIButton) {
        performSegue(withIdentifier: "gameEndUnwindSegueToHomeVC", sender: self)
    }
}
