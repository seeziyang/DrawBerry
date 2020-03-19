//
//  PaletteObserver.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 19/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

protocol PaletteObserver {
    func undo()

    func select(tool: PKTool)
}
