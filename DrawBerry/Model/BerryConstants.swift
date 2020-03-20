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
    static let strokeLength: CGFloat = 40
    static let strokeWidth: CGFloat = 30
    static let defaultInkWidth: CGFloat = 0.5
    static let fullOpacity: CGFloat = 1
    static let unselectedOpacity: CGFloat = 0.3

    static let UIColorToAssetName = [
        berryBlack: "black",
        berryGrey: "grey",
        berryBlue: "blue",
        berryRed: "red"
    ]

    static let strokeToAssetName = [
        Stroke.thick: "thick",
        Stroke.medium: "medium",
        Stroke.thin: "thin"
    ]

    static let paperBackgroundImage = UIImage(named: "paper-brown")
    static let deleteIcon = UIImage(named: "delete")
    static let eraserIcon = UIImage(named: "eraser")

    static let berryBlack = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let berryGrey = UIColor(red: 164 / 255, green: 164 / 255, blue: 164 / 255, alpha: 1)
    static let berryBlue = UIColor(red: 10 / 255, green: 128 / 255, blue: 146 / 255, alpha: 1)
    static let berryRed = UIColor(red: 242 / 255, green: 49 / 255, blue: 60 / 255, alpha: 1)
    static let berryGreen = UIColor(red: 242 / 255, green: 49 / 255, blue: 60 / 255, alpha: 1)

    static let thickIcon = UIImage(named: "thick")
    static let mediumIcon = UIImage(named: "medium")
    static let thinIcon = UIImage(named: "thin")
}
