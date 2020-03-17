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
            return
        }
        syncHistory(on: canvas)
    }
    
    func syncHistory(on canvas: Canvas) {
        let prevSize = history.last?.dataRepresentation().count ?? PKDrawing().dataRepresentation().count
        if prevSize < canvas.drawing.dataRepresentation().count {
            // A stroke was added
            updateHistory(with: canvas.drawing)
            numberOfStrokes += 1
            return
        }
        if prevSize > canvas.drawing.dataRepresentation().count {
            // A stroke was deleted
            updateHistory(with: canvas.drawing)
            numberOfStrokes -= 1
            return
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
        numberOfStrokes -= 1
        guard let lastDrawing = history.last else {
            return PKDrawing()
        }
        print(history)
        return lastDrawing
    }

    func clear() {
        updateHistory(with: PKDrawing())
        numberOfStrokes = 0
    }
}
