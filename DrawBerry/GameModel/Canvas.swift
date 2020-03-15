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
    
    var numberOfStrokes: Int { get }

    var drawing: PKDrawing { get }

    var isClearButtonEnabled: Bool { get set }

    var selectedInkTool: PKInkingTool? { get }

    var isEraserSelected: Bool { get }

    func undo()

    func setTool(to tool: PKTool)
}
