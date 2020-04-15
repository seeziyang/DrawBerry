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
    var defaultRotationValue: CGFloat = 0

    required init?(coder: NSCoder) {
        nil
    }

    internal init?(bounds: CGRect, canvas: CompetitiveCanvas) {
        self.decoratedCanvas = canvas
        super.init(canvas: canvas as? BerryCanvas ?? BerryCanvas())
    }

    static func decoratedCanvasFrom(canvas: CompetitiveCanvas) -> InvulnerableBerryCanvas? {
        InvulnerableBerryCanvas(bounds: canvas.bounds, canvas: canvas)
    }

    func addInkSplotch() {
        // Does nothing because the user is invulnerable
    }

    func rotateCanvas(by rotationValue: CGFloat) {
        guard let rotation = decoratedCanvas?.transform.rotated(by: defaultRotationValue) else {
            return
        }
        decoratedCanvas?.transform = rotation
    }

    func hideDrawing() {
        // Does nothing because the user is invulnerable
    }

    func showDrawing() {
        decoratedCanvas?.isHidden = false
    }
}
