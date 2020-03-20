//
//  Stroke.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 20/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

enum Stroke: CGFloat {
    case thick = 10
    case medium = 5
    case thin = 1

    static func strokeExists(thickness: CGFloat) -> Bool {
        return thickness == thick.rawValue || thickness == medium.rawValue || thickness == thin.rawValue
    }
}
