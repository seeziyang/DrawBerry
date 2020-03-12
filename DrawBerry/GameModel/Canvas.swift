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
    var numberOfStrokes: Int { get }

    var drawing: PKDrawing { get }

    var isClearButtonEnabled: Bool { get set }

    func undo()
}
