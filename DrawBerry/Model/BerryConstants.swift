//
//  BerryConstants.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

struct BerryConstants {
    static let canvasPadding: CGFloat = 10
    static let paletteHeight: CGFloat = 60
    static let buttonRadius: CGFloat = 40
    static let minimumCanvasWidth: CGFloat = 300
    static let minimumCanvasHeight: CGFloat = 500

    static let palettePadding: CGFloat = 10
    static let toolLength: CGFloat = 40
    static let defaultInkWidth: CGFloat = 0.5
    static let fullOpacity: CGFloat = 1
    static let halfOpacity: CGFloat = 0.5

    static let UIColorToAssetName = [
        UIColor.black: "black",
        UIColor.blue: "blue",
        UIColor.red: "red"
    ]

    static let paperBackgroundImage = UIImage(named: "paper-brown")
    static let deleteIcon = UIImage(named: "delete")
    static let eraserIcon = UIImage(named: "eraser")
}
