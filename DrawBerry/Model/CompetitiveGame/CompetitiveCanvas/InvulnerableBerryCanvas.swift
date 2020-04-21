//
//  InvulnerableBerryCanvas.swift
//  DrawBerry
//
//  Created by Jon Chua on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class InvulnerableBerryCanvas: BerryCanvas, CompetitiveCanvas {
    var decoratedCanvas: CompetitiveCanvas?
    var defaultRotationValue: CGFloat

    required init?(coder: NSCoder) {
        nil
    }

    internal init?(bounds: CGRect, canvas: CompetitiveCanvas) {
        self.decoratedCanvas = canvas
        self.defaultRotationValue = canvas.defaultRotationValue
        super.init(canvas: canvas as? BerryCanvas ?? BerryCanvas())
    }

    static func decoratedCanvasFrom(canvas: CompetitiveCanvas) -> InvulnerableBerryCanvas? {
        InvulnerableBerryCanvas(bounds: canvas.bounds, canvas: canvas)
    }

    func addInkSplotch(image: UIImageView) {
        // Does nothing because the user is invulnerable
    }

    func rotateCanvas(rotationValue: CGFloat) {
        guard let canvas = decoratedCanvas else {
            return
        }
        canvas.rotateCanvas(rotationValue: canvas.defaultRotationValue)
    }

    func hideDrawing() {
        // Does nothing because the user is invulnerable
    }

    func showDrawing() {
        decoratedCanvas?.showDrawing()
    }
}
