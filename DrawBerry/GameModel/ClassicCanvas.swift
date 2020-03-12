//
//  ClassicCanvas.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

class ClassicCanvas: UIView, Canvas {
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
        canvasView.drawing = lastDrawing
    }

    static func createCanvas(within bounds: CGRect) -> ClassicCanvas? {
        if outOfBounds(bounds: bounds) {
            return nil
        }
        return ClassicCanvas(frame: bounds)
    }

    private static func outOfBounds(bounds: CGRect) -> Bool {
        return bounds.width < minimumWidth || bounds.height < minimumHeight
    }

    private override init(frame: CGRect) {
        palatte = ClassicCanvas.createPalette(within: frame)
        canvasView = ClassicCanvas.createCanvasView(within: frame)
        background = ClassicCanvas.createBackground(within: frame)
        clearButton = ClassicCanvas.createClearButton(within: frame)
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
    }

    private func addComponentsToCanvas() {
        addSubview(background)
        addSubview(canvasView)
        addSubview(palatte)
        addSubview(clearButton)
    }

    private static func createBackground(within bounds: CGRect) -> UIView {
        let background = UIImageView(frame: ClassicCanvas.getBackgroundRect(within: bounds))
        background.image = UIImage(named: "paper-brown")
        return background
    }

    private static func createCanvasView(within bounds: CGRect) -> PKCanvasView {
        let newCanvasView = PKCanvasView(frame: ClassicCanvas.getCanvasRect(within: bounds))
        newCanvasView.allowsFingerDrawing = true
        newCanvasView.isOpaque = false
        newCanvasView.isUserInteractionEnabled = true
        return newCanvasView
    }

    private static func createPalette(within bounds: CGRect) -> UIView {
        let newPalette = UIView(frame: ClassicCanvas.getPalatteRect(within: bounds))
        // For visualisation of palatte location during dev
        newPalette.layer.borderWidth = 3
        newPalette.layer.borderColor = UIColor.red.cgColor
        return newPalette
    }

    private static func createClearButton(within bounds: CGRect) -> UIButton {
        let button = UIButton(frame: ClassicCanvas.getClearButtonRect(within: bounds))
        let icon = UIImage(named: "delete")
        button.setImage(icon , for: .normal)
        return button
    }

    @objc func clearButtonTap() {
        canvasView.drawing = PKDrawing()
        history.append(canvasView.drawing)
    }

    private static func getClearButtonRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: clearButtonRadius, height: clearButtonRadius)
        let origin = CGPoint(
            x: bounds.width - clearButtonRadius - ClassicCanvas.canvasPadding,
            y: ClassicCanvas.canvasPadding)
        return CGRect(origin: origin, size: size)
    }

    private static func getCanvasRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: bounds.height - ClassicCanvas.palatteHeight)
        let origin = CGPoint.zero
        return CGRect(origin: origin, size: size)
    }

    private static func getPalatteRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: ClassicCanvas.palatteHeight)
        let origin = CGPoint(x: 0, y: bounds.height - ClassicCanvas.palatteHeight)
        return CGRect(origin: origin, size: size)
    }

    private static func getBackgroundRect(within bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint.zero, size: bounds.size)
    }
}
