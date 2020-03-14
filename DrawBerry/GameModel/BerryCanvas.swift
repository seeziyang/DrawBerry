//
//  ClassicCanvas.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

class BerryCanvas: UIView, UIGestureRecognizerDelegate, Canvas {
    var isAbleToDraw = true

    var canvasView: PKCanvasView
    let palatte: UIView
    let background: UIView
    var history: [PKDrawing] = []
    var clearButton: UIButton

    var isClearButtonEnabled: Bool {
        didSet {
            clearButton.isEnabled = isClearButtonEnabled
            clearButton.isHidden = !isClearButtonEnabled
        }
    }

    var numberOfStrokes: Int {
        history.count
    }

    var drawing: PKDrawing {
        canvasView.drawing
    }

    static let canvasPadding: CGFloat = 10
    static let palatteHeight: CGFloat = 60
    static let clearButtonRadius: CGFloat = 40
    static let minimumWidth: CGFloat = 300
    static let minimumHeight: CGFloat = 500

    func undo() {
        if history.isEmpty {
            return
        }
        _ = history.popLast()
        guard let lastDrawing = history.last else {
            canvasView.drawing = PKDrawing()
            return
        }
        print(lastDrawing)
        canvasView.drawing = lastDrawing
    }

    static func createCanvas(within bounds: CGRect) -> BerryCanvas? {
        if outOfBounds(bounds: bounds) {
            return nil
        }
        return BerryCanvas(frame: bounds)
    }

    private static func outOfBounds(bounds: CGRect) -> Bool {
        return bounds.width < minimumWidth || bounds.height < minimumHeight
    }

    private override init(frame: CGRect) {
        palatte = BerryCanvas.createPalette(within: frame)
        canvasView = BerryCanvas.createCanvasView(within: frame)
        background = BerryCanvas.createBackground(within: frame)
        clearButton = BerryCanvas.createClearButton(within: frame)
        isClearButtonEnabled = true

        super.init(frame: frame)
        bindGestureRecognizers()
        addComponentsToCanvas()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    private func bindGestureRecognizers() {
        clearButton.addTarget(self, action: #selector(clearButtonTap), for: .touchUpInside)
        let draw = UIPanGestureRecognizer(target: self, action: #selector(handleDraw(recognizer:)))
        draw.delegate = self
        guard let dgrView = retrieveDrawingView() else {
            return
        }
        dgrView.addGestureRecognizer(draw)
    }

    private func retrieveDrawingView() -> UIView? {
        let nestedSubviews = canvasView.subviews.map {$0.subviews}
        var allSubviews: [UIView] = []
        nestedSubviews.forEach {allSubviews += $0}
        let dgrView = allSubviews.filter {$0 == canvasView.drawingGestureRecognizer.view}
        if dgrView.count != 1 {
            return nil
        }
        return dgrView[0]
    }

    @objc func handleDraw(recognizer: UIPanGestureRecognizer) {
        if !isAbleToDraw {
            recognizer.state = .ended
        }

        if recognizer.state == .ended {
            canvasView.drawingGestureRecognizer.state = .ended

            let currentDrawing = canvasView.drawing
            history.append(currentDrawing)
        }
    }

    private func addComponentsToCanvas() {
        addSubview(background)
        addSubview(canvasView)
        addSubview(palatte)
        addSubview(clearButton)
    }

    private static func createBackground(within bounds: CGRect) -> UIView {
        let background = UIImageView(frame: getBackgroundRect(within: bounds))
        background.image = UIImage(named: "paper-brown")
        return background
    }

    private static func createCanvasView(within bounds: CGRect) -> PKCanvasView {
        let newCanvasView = PKCanvasView(frame: getCanvasRect(within: bounds))
        newCanvasView.allowsFingerDrawing = true
        newCanvasView.isOpaque = false
        newCanvasView.isUserInteractionEnabled = true
        return newCanvasView
    }

    private static func createPalette(within bounds: CGRect) -> UIView {
        let newPalette = UIView(frame: getPalatteRect(within: bounds))
        // For visualisation of palatte location during dev
        newPalette.layer.borderWidth = 3
        newPalette.layer.borderColor = UIColor.red.cgColor
        populate(palette: newPalette)
        return newPalette
    }

    private static func populate(palette: UIView) {
        // TODO: Add functionality for palette
        let button = UIButton(frame: getUndoButtonRect(within: palette.bounds))
        let icon = UIImage(named: "delete")
        button.setImage(icon , for: .normal)
        palette.addSubview(button)
    }

    private static func createClearButton(within bounds: CGRect) -> UIButton {
        let button = UIButton(frame: getClearButtonRect(within: bounds))
        let icon = UIImage(named: "delete")
        button.setImage(icon , for: .normal)
        return button
    }

    @objc func clearButtonTap() {
        canvasView.drawing = PKDrawing()
        history.append(canvasView.drawing)
    }

    @objc func undoButtonTap() {
        undo()
    }

    private static func getClearButtonRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: clearButtonRadius, height: clearButtonRadius)
        let origin = CGPoint(
            x: bounds.width - clearButtonRadius - BerryCanvas.canvasPadding,
            y: BerryCanvas.canvasPadding)
        return CGRect(origin: origin, size: size)
    }

    private static func getUndoButtonRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: clearButtonRadius, height: clearButtonRadius)
        let origin = CGPoint(
            x: bounds.width - clearButtonRadius - BerryCanvas.canvasPadding,
            y: BerryCanvas.canvasPadding)
        return CGRect(origin: origin, size: size)
    }

    private static func getCanvasRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: bounds.height - BerryCanvas.palatteHeight)
        let origin = CGPoint.zero
        return CGRect(origin: origin, size: size)
    }

    private static func getPalatteRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: BerryCanvas.palatteHeight)
        let origin = CGPoint(x: 0, y: bounds.height - BerryCanvas.palatteHeight)
        return CGRect(origin: origin, size: size)
    }

    private static func getBackgroundRect(within bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint.zero, size: bounds.size)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
            -> Bool {
        return isAbleToDraw
    }
}
