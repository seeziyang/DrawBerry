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
    var palatte: UIView
    lazy var clearButton: UIButton = {
        createClearButton(within: self.bounds)
    }()
    
    var isClearButtonEnabled: Bool {
        didSet {
            clearButton.isEnabled = isClearButtonEnabled
            clearButton.isHidden = !isClearButtonEnabled
        }
    }

    static let canvasPadding: CGFloat = 10
    static let palatteHeight: CGFloat = 60
    static let clearButtonRadius: CGFloat = 40
    static let minimumWidth: CGFloat = 300
    static let minimumHeight: CGFloat = 500

    func getDrawing() -> PKDrawing {
        return canvasView.drawing
    }

    static func createCanvas(within bounds: CGRect) -> ClassicCanvas? {
        if bounds.width < minimumWidth || bounds.height < minimumHeight {
            return nil
        }
        return ClassicCanvas(frame: bounds)
    }

    private override init(frame: CGRect) {
        canvasView = PKCanvasView(frame: ClassicCanvas.getCanvasRect(within: frame))
        canvasView.allowsFingerDrawing = true

        palatte = ClassicCanvas.createPalette(within: frame)
        isClearButtonEnabled = true
        super.init(frame: frame)
        addComponentsToCanvas()
        // For visualisation of canvas and palatte during development
        layer.borderWidth = 3
        layer.borderColor = UIColor.red.cgColor
    }

    required init?(coder: NSCoder) {
        return nil
    }

    private func addComponentsToCanvas() {
        addSubview(canvasView)
        addSubview(palatte)
        addSubview(clearButton)
    }

    private static func createPalette(within bounds: CGRect) -> UIView {
        let newPalette = UIView(frame: ClassicCanvas.getPalatteRect(within: bounds))
        newPalette.layer.borderWidth = 3
        newPalette.layer.borderColor = UIColor.red.cgColor
        return newPalette
    }

    private func createClearButton(within bounds: CGRect) -> UIButton {
        let button = UIButton(frame: ClassicCanvas.getClearButtonRect(within: bounds))
        let icon = UIImage(named: "delete")
        button.setImage(icon , for: .normal)
        button.addTarget(self, action: #selector(clearButtonTap), for: .touchUpInside)
        return button
    }

    @objc func clearButtonTap() {
        canvasView.drawing = PKDrawing()
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
}
