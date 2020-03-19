//
//  CanvasTest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
import PencilKit
@testable import DrawBerry

class BerryCanvasTest: XCTestCase {
    var canvas: BerryCanvas!
    // Defined for the convinience of testing.

    override func setUp() {
        canvas = BerryCanvas(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 500, height: 500)))
        canvas.delegate = self
        super.setUp()
    }

    func testInitialise() {
        XCTAssertEqual(canvas.numberOfStrokes, 0)
        XCTAssertTrue(canvas.history.isEmpty)
        XCTAssertEqual(canvas.drawing.dataRepresentation().count, PKDrawing().dataRepresentation().count)
    }

    func testEraser() {
        canvas.palette.isEraserSelected = true
        XCTAssertTrue(canvas.isEraserSelected)
        XCTAssertNil(canvas.selectedInkTool)
    }

    func testSelectInk() {
        let firstTool = canvas.palette.inks[0]
        canvas.setTool(to: firstTool)
        XCTAssertFalse(canvas.isEraserSelected)
        guard let selectedTool = canvas.selectedInkTool else {
            XCTFail("Selected tool should not be nil")
            return
        }
        XCTAssertEqual(selectedTool, firstTool)
    }

    func testClearButtonEnabled() {
        canvas.isClearButtonEnabled = true
        XCTAssertTrue(canvas.clearButton.isEnabled)
        XCTAssertFalse(canvas.clearButton.isHidden)

        canvas.isClearButtonEnabled = false
        XCTAssertFalse(canvas.clearButton.isEnabled)
        XCTAssertTrue(canvas.clearButton.isHidden)
    }

    func testUndoButtonEnabled() {
        canvas.isUndoButtonEnabled = true
        XCTAssertTrue(canvas.palette.undoButton?.isEnabled ?? false)
        XCTAssertFalse(canvas.palette.undoButton?.isHidden ?? true)

        canvas.isUndoButtonEnabled = false
        XCTAssertFalse(canvas.palette.undoButton?.isEnabled ?? true)
        XCTAssertTrue(canvas.palette.undoButton?.isHidden ?? false)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension BerryCanvasTest: CanvasDelegate {
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
