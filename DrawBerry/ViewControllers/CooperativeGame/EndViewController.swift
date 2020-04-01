//
//  EndViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class EndViewController: CooperativeGameViewController {
    var cooperativeGame: CooperativeGame!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCanvasToView()
        populateDrawings()
        addMenuButtonWithDelay()
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        self.view.addSubview(canvasBackground)
    }

    private func populateDrawings() {
        cooperativeGame.allDrawings.forEach {
            let imageView = UIImageView(frame: self.view.frame)
            imageView.image = $0
            imageView.contentMode = .scaleAspectFit
            self.view.addSubview(imageView)
        }
    }

    private func addMenuButtonWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addMenuButtonToView()
        }
    }

    private func addMenuButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 250,
                              width: 100, height: 50)
        button.backgroundColor = .systemYellow
        button.setTitle("Main Menu", for: .normal)
        button.addTarget(self, action: #selector(backOnTap(sender:)), for: .touchUpInside)

        view.addSubview(button)
    }

    @objc private func backOnTap(sender: UIButton) {
        navigateToMainMenu()
    }

    private func navigateToMainMenu() {
        performSegue(withIdentifier: "segueToMainMenu", sender: self)
    }
}
