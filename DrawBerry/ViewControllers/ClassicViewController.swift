//
//  ClassicViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 10/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

class ClassicViewController: UIViewController {
    var classicGame: ClassicGame!
    var canvas: Canvas!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCanvasToView()
        addDoneButtonToView()
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        canvas.isClearButtonEnabled = true
        canvas.isUndoButtonEnabled = true
        canvas.delegate = self
        self.view.addSubview(canvas)
        self.canvas = canvas
    }

    private func addDoneButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 250,
                              width: 100, height: 50)
        button.backgroundColor = .systemYellow
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneOnTap(sender:)), for: .touchUpInside)

        self.view.addSubview(button)
    }

    @objc private func doneOnTap(sender: UIButton) {
        finishRound()
    }

    private func finishRound() {

    }
}

extension ClassicViewController: CanvasDelegate {
    func handleDraw(recognizer: UIPanGestureRecognizer, canvas: Canvas) {
        if !canvas.isAbleToDraw {
            recognizer.state = .ended
            recognizer.isEnabled = false
            return
        }
        if recognizer.state == .ended {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.syncHistory(on: canvas)
            }
        }
    }

    func syncHistory(on canvas: Canvas) {
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

    /// Undo the drawing to the previous state one stroke before.
    func undo(on canvas: Canvas) -> PKDrawing {
        if canvas.history.isEmpty {
            return PKDrawing()
        }
        _ = canvas.history.popLast()
        canvas.numberOfStrokes -= 1
        guard let lastDrawing = canvas.history.last else {
            return PKDrawing()
        }
        return lastDrawing
    }

    func clear(canvas: Canvas) {
        updateHistory(on: canvas, with: PKDrawing())
        canvas.numberOfStrokes = 0
    }
}
