//
//  BerryPaletteDelegate.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

class BerryPaletteDelegate: PaletteDelegate {
    var selectedInkTool: PKInkingTool? {
        didSet {
            if selectedInkTool != nil {
                isEraserSelected = false
            }
        }
    }

    var isEraserSelected: Bool = false {
        didSet {
            if isEraserSelected {
                selectedInkTool = nil
            }
        }
    }
}
