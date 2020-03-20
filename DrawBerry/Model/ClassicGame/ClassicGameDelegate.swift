//
//  ClassicGameDelegate.swift
//  DrawBerry
//
//  Created by See Zi Yang on 19/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol ClassicGameDelegate: AnyObject {
    func drawingsDidUpdate()

    // TOOD: do each player's drawing by index instead of all drawings?
}
