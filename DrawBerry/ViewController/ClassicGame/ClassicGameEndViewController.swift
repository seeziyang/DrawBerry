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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addDoneButtonToView()
    }

    private func addDoneButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 250,
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
