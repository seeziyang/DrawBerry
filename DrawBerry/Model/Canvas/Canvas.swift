//
//  Canvas.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 10/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

protocol Canvas: UIView {
    // Add methods here if necessary, I will implement them
    var isAbleToDraw: Bool { get set }

    var numberOfStrokes: Int { get set }

    var drawing: PKDrawing { get }

    var isClearButtonEnabled: Bool { get set }

    var isUndoButtonEnabled: Bool { get set }

    var history: [PKDrawing] { get set }

    var delegate: CanvasDelegate? { get set }

    var currentCoordinate: CGPoint? { get }

    func undo()

    func select(tool: PKTool)

    func randomiseInkTool()
}

extension Canvas {
    var drawingImage: UIImage {
        // TODO: can increase scale later to account for iphones having smaller screen
        drawing.image(from: drawing.bounds, scale: 1.0)
    }
}
