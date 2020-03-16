//
//  BerryCanvasDelegate.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

class BerryCanvasDelegate: CanvasDelegate {
    var history: [PKDrawing] = []
    var numberOfStrokes: Int = 0

    func handleDraw(recognizer: UIPanGestureRecognizer, canvas: Canvas) {
        if !canvas.isAbleToDraw {
            recognizer.state = .ended
            recognizer.isEnabled = false
        }
        if !canvas.isEraserSelected && recognizer.state == .ended {
            updateHistory(with: canvas.drawing)
            numberOfStrokes += 1
        }
        guard let prevSize = history.last?.dataRepresentation().count else {
            return
        }
        if prevSize > canvas.drawing.dataRepresentation().count {
            // A stroke was deleted
            updateHistory(with: canvas.drawing)
            numberOfStrokes -= 1
        }
    }

    func updateHistory(with drawing: PKDrawing) {
        history.append(drawing)
    }

    /// Undo the drawing to the previous state one stroke before.
    func undo() -> PKDrawing {
        if history.isEmpty {
            return PKDrawing()
        }
        _ = history.popLast()
        guard let lastDrawing = history.last else {
            return PKDrawing()
        }
        return lastDrawing
    }

    func clear() {
        updateHistory(with: PKDrawing())
        numberOfStrokes = 0
    }
}
