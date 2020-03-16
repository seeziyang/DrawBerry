//
//  CanvasDelegate.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

protocol CanvasDelegate {

    func handleDraw(recognizer: UIPanGestureRecognizer, canvas: Canvas)

    func updateHistory(with drawing: PKDrawing)

    func undo() -> PKDrawing

    func clear()

    var history: [PKDrawing] { get set }

    var numberOfStrokes: Int { get }
}
