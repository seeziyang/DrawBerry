//
//  MultiplayerPlayer.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

protocol MultiplayerPlayer: ComparablePlayer {
    func addDrawing(image: UIImage)

    func getDrawingImage() -> UIImage?
}
