//
//  CompetitiveBerryCanvas.swift
//  DrawBerry
//
//  Created by Jon Chua on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveBerryCanvas: BerryCanvas, CompetitiveCanvas {
    var decoratedCanvas: CompetitiveCanvas?
    var defaultRotationValue: CGFloat = 0

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
    func addInkSplotch(image: UIImageView) {
        assert(self.bounds.contains(image.bounds))
        self.addSubview(image)
        self.bringSubviewToFront(image)
    }

    /// Rotates the canvas by the provided `rotationValue` in radians.
    func rotateCanvas(rotationValue: CGFloat) {
        transform = CGAffineTransform(rotationAngle: rotationValue)
    }

    func hideDrawing() {
        isHidden = true
    }

    func showDrawing() {
        isHidden = false
    }
}
