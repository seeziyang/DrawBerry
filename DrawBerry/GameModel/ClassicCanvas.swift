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

    static let palatteHeight: CGFloat = 60
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
        palatte = ClassicCanvas.createPalette(within: frame)
        canvasView.allowsFingerDrawing = true
        super.init(frame: frame)
        addSubview(canvasView)
        addSubview(palatte)
        // For visualisation of canvas and palatte during development
        layer.borderWidth = 10
        layer.borderColor = UIColor.red.cgColor
    }

    required init?(coder: NSCoder) {
        return nil
    }

    private static func createPalette(within bounds: CGRect) -> UIView {
        let newPalette = UIView(frame: ClassicCanvas.getPalatteRect(within: bounds))
        newPalette.layer.borderWidth = 5
        newPalette.layer.borderColor = UIColor.red.cgColor
        return newPalette
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
