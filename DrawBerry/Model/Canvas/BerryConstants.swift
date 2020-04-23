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

    static let UIColorToAsset = [
        berryBlack: #imageLiteral(resourceName: "black"),
        berryGrey: #imageLiteral(resourceName: "grey"),
        berryBlue: #imageLiteral(resourceName: "blue"),
        berryRed: #imageLiteral(resourceName: "red")
    ]

    static let strokeToAsset = [
        Stroke.thick: thickIcon,
        Stroke.medium: mediumIcon,
        Stroke.thin: thinIcon
    ]

    static let selectedStrokeToAsset = [
        Stroke.thick: thickIconSelected,
        Stroke.medium: mediumIconSelected,
        Stroke.thin: thinIconSelected
    ]

    static let paperBackgroundImage = #imageLiteral(resourceName: "paper-brown")
    static let deleteIcon = #imageLiteral(resourceName: "delete")
    static let eraserIcon = #imageLiteral(resourceName: "eraser")

    static let berryBlack = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let berryGrey = #colorLiteral(red: 164 / 255, green: 164 / 255, blue: 164 / 255, alpha: 1)
    static let berryBlue = #colorLiteral(red: 10 / 255, green: 128 / 255, blue: 146 / 255, alpha: 1)
    static let berryRed = #colorLiteral(red: 242 / 255, green: 49 / 255, blue: 60 / 255, alpha: 1)
    static let berryGreen =  #colorLiteral(red: 242 / 255, green: 49 / 255, blue: 60 / 255, alpha: 1)

    static let thickIcon = #imageLiteral(resourceName: "thick")
    static let mediumIcon = #imageLiteral(resourceName: "medium")
    static let thinIcon = #imageLiteral(resourceName: "thin")

    static let thickIconSelected = #imageLiteral(resourceName: "thick-selected")
    static let mediumIconSelected = #imageLiteral(resourceName: "medium-selected")
    static let thinIconSelected = #imageLiteral(resourceName: "thin-selected")
}
