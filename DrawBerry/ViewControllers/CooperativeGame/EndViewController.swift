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
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        self.view.addSubview(canvasBackground)
    }

    private func populateDrawings() {
        let canvasHeight = self.view.bounds.height - BerryConstants.paletteHeight
        let canvasWidth = self.view.bounds.width
        let drawingSpaceHeight = canvasHeight / CGFloat(cooperativeGame.players.count)
        var verticalDisp: CGFloat = 0
        cooperativeGame.allDrawings.forEach {
            let imageView = UIImageView(
                frame: CGRect(x: 0, y: verticalDisp, width: canvasWidth, height: drawingSpaceHeight)
            )
            imageView.image = $0
            self.view.addSubview(imageView)
            verticalDisp += drawingSpaceHeight
        }
    }
}
