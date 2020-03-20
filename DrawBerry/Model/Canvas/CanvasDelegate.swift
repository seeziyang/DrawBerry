//
//  CanvasDelegate.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

protocol CanvasDelegate: AnyObject {
    func handleDraw(recognizer: UIGestureRecognizer, canvas: Canvas)

    func undo(on canvas: Canvas) -> PKDrawing

    func clear(canvas: Canvas)
}
