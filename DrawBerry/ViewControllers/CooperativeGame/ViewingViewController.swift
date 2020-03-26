//
//  ViewingViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class ViewingViewController: UIViewController {
    var cooperativeGame: CooperativeGame!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCanvasToView()
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        self.view.addSubview(canvasBackground)
    }

    func navigateToEndPage() {
        performSegue(withIdentifier: "segueToEnd", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let drawingVC = segue.destination as? DrawingViewController {
            drawingVC.cooperativeGame = cooperativeGame
        }
    }

}

