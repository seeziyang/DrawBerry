//
//  ClassicViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 10/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

// TODO: rename topLeftCanvas to just canvas since classic game only one canvas
class ClassicViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCanvasesToView()
    }

    private func addCanvasesToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let topLeftCanvas: Canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        topLeftCanvas.isClearButtonEnabled = true
        topLeftCanvas.isUndoButtonEnabled = true
        topLeftCanvas.delegate = self
        self.view.addSubview(topLeftCanvas)
    }
}

extension ClassicViewController: CanvasDelegate {
    func handleDraw(recognizer: UIGestureRecognizer, canvas: Canvas) {
        if !canvas.isAbleToDraw {
            recognizer.state = .ended
            recognizer.isEnabled = false
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

    func updateHistory(on canvas: Canvas, with drawing: PKDrawing) {
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
        return popHistory(from: canvas)
    }

    func clear(canvas: Canvas) {
        updateHistory(on: canvas, with: PKDrawing())
        canvas.numberOfStrokes = 0
    }
}
