//
//  UIViewController+CanvasDelegate.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 19/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

class CanvasDelegateViewController: UIViewController, CanvasDelegate {
    func handleDraw(recognizer: UIGestureRecognizer, canvas: Canvas) {
        if !canvas.isAbleToDraw {
            recognizer.state = .ended
            recognizer.isEnabled = false
            return
        }
        let position = recognizer.location(in: recognizer.view)
        if !canvas.isWithinDrawableLimit(position: position) {
            canvas.isAbleToDraw = false
            canvas.isAbleToDraw = true
            return
        }
        if recognizer.state == .ended {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.syncStroke(to: canvas)
            }
        }
    }

    private func syncStroke(to canvas: Canvas) {
        let prevSize = canvas.history.last?.dataRepresentation().count ?? PKDrawing().dataRepresentation().count
        if prevSize < canvas.drawing.dataRepresentation().count {
            // A stroke was added
            updateHistory(on: canvas, with: canvas.drawing)
            canvas.numberOfStrokes += 1
            return
        }
        if prevSize > canvas.drawing.dataRepresentation().count {
            // A stroke was deleted
            updateHistory(on: canvas, with: canvas.drawing)
            canvas.numberOfStrokes -= 1
            return
        }
    }

    private func updateHistory(on canvas: Canvas, with drawing: PKDrawing) {
        canvas.history.append(drawing)
    }

    private func popHistory(from canvas: Canvas) -> PKDrawing {
        let currentDrawing = canvas.drawing
        _ = canvas.history.popLast()
        if canvas.history.isEmpty {
            return PKDrawing()
        }
        guard let lastDrawing = canvas.history.last else {
            return PKDrawing()
        }
        if currentDrawing.dataRepresentation().count < lastDrawing.dataRepresentation().count {
            canvas.numberOfStrokes -= 1
        }
        if currentDrawing.dataRepresentation().count > lastDrawing.dataRepresentation().count {
            canvas.numberOfStrokes += 1
        }
        return lastDrawing
    }

    /// Undo the drawing to the previous state one stroke before.
    func undo(on canvas: Canvas) -> PKDrawing {
        popHistory(from: canvas)
    }

    func clear(canvas: Canvas) {
        updateHistory(on: canvas, with: PKDrawing())
        canvas.numberOfStrokes = 0
    }
}
