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

    func addInkSplotch()
    func rotateCanvas(by rotationValue: CGFloat)
    func hideDrawing()
    func showDrawing()
}
