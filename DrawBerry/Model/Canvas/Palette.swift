//
//  Palette.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

protocol Palette: AnyObject {
    var isEraserEnabled: Bool { get set }

    var isUndoButtonEnabled: Bool { get set }

    func add(color: UIColor)

    func add(stroke: Stroke)

    func selectFirstColorFirstStroke()

    func setObserver(_ newObserver: PaletteObserver)

    func randomiseInkTool()

    func contains(tool: PKTool) -> Bool
}
