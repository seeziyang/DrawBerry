//
//  PaletteDelegate.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

protocol PaletteDelegate {
    var selectedInkTool: PKInkingTool? { get set }

    var isEraserSelected: Bool { get set }
}
