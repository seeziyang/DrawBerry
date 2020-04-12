//
//  CompetitiveBerryCanvas.swift
//  DrawBerry
//
//  Created by Jon Chua on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveBerryCanvas: BerryCanvas, CompetitiveCanvas {
    required init?(coder: NSCoder) {
        nil
    }

    internal init?(bounds: CGRect) {
        super.init(frame: bounds)
    }

    /// Creates a `CompetitiveCanvas` with the given bounds.
    static func createCompetitiveCanvas(within bounds: CGRect) -> CompetitiveCanvas? {
        CompetitiveBerryCanvas(bounds: bounds)
    }

    /// Adds an ink splotch to the canvas.
    func addInkSplotch() {
        let inkSplotch = UIImageView(image: PowerupAssets.inkSplotchUIImage)

        let randomWidth = CGFloat.random(in: 100...350)
        let randomHeight = CGFloat.random(in: 100...350)

        inkSplotch.frame = CGRect(x: .random(in: 0...bounds.maxX - randomWidth),
                                  y: .random(in: 0...bounds.maxY - randomHeight),
                                  width: randomWidth, height: randomHeight)

        self.addSubview(inkSplotch)
        self.bringSubviewToFront(inkSplotch)
    }

    /// Rotates the canvas by the provided `rotationValue` in radians.
    func rotateCanvas(by rotationValue: CGFloat) {
        transform = self.transform.rotated(by: rotationValue)
    }

    func hideDrawing() {
        isHidden = true
    }

    func showDrawing() {
        isHidden = false
    }
}
