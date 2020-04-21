//
//  CompetitiveCanvas.swift
//  DrawBerry
//
//  Created by Jon Chua on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol CompetitiveCanvas: Canvas {
    var decoratedCanvas: CompetitiveCanvas? { get set }
    var defaultRotationValue: CGFloat { get set }

    func getNumberOfStrokes() -> Int

    func addInkSplotch(image: UIImageView)
    func rotateCanvas(rotationValue: CGFloat)
    func hideDrawing()
    func showDrawing()
}

extension CompetitiveCanvas {
    func getNumberOfStrokes() -> Int {
        guard let innerCanvas = decoratedCanvas else {
            return numberOfStrokes
        }
        return numberOfStrokes + innerCanvas.getNumberOfStrokes()
    }
}
