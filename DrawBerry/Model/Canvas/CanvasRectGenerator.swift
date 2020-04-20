//
//  CanvasRectGenerator.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 20/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

struct CanvasRectGenerator {
    /// Returns the `CGRect` for the `InkView` given the bounds and the horizontal displacement.
    static func getInkViewRect(within bounds: CGRect, horizontalDisplacement: CGFloat) -> CGRect {
        let size = CGSize(width: BerryConstants.toolLength, height: BerryConstants.toolLength)
        let origin = CGPoint(
            x: horizontalDisplacement + BerryConstants.palettePadding,
            y: BerryConstants.palettePadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the `StrokeView` given the bounds and the origin of the right UI element.
    static func getStrokeViewRect(within bounds: CGRect, rightNeighbourOrigin: CGPoint) -> CGRect {
        let size = CGSize(width: BerryConstants.strokeWidth, height: BerryConstants.strokeLength)
        let origin = CGPoint(
            x: rightNeighbourOrigin.x - BerryConstants.strokeWidth - BerryConstants.palettePadding,
            y: BerryConstants.palettePadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the eraser view given the bounds and the origin of the right UI element.
    static func getEraserRect(within bounds: CGRect, rightNeighbourOrigin: CGPoint) -> CGRect {
        let size = CGSize(width: BerryConstants.toolLength, height: BerryConstants.toolLength)
        let origin = CGPoint(
            x: rightNeighbourOrigin.x - BerryConstants.toolLength - BerryConstants.canvasPadding,
            y: BerryConstants.palettePadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the undo button given the bounds.
    static func getUndoButtonRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: BerryConstants.buttonRadius, height: BerryConstants.buttonRadius)
        let origin = CGPoint(
            x: bounds.width - BerryConstants.buttonRadius - BerryConstants.canvasPadding,
            y: BerryConstants.canvasPadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the clear button given the bounds.
    static func getClearButtonRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: BerryConstants.buttonRadius, height: BerryConstants.buttonRadius)
        let origin = CGPoint(
            x: bounds.width - BerryConstants.buttonRadius - BerryConstants.canvasPadding,
            y: BerryConstants.canvasPadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the canvas button given the bounds.
    static func getCanvasRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: bounds.height - BerryConstants.paletteHeight)
        let origin = CGPoint.zero
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the `Palette` given the bounds.
    static func getPalatteRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: BerryConstants.paletteHeight)
        let origin = CGPoint(x: 0, y: bounds.height - BerryConstants.paletteHeight)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the background given the bounds.
    static func getBackgroundRect(within bounds: CGRect) -> CGRect {
        CGRect(origin: CGPoint.zero, size: bounds.size)
    }

}
