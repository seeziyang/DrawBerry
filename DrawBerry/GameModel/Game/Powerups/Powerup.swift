//
//  Powerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol Powerup: AnyObject {
    var image: UIImage? { get }
    var owner: Player { get }
    var targets: [Player] { get }
    var location: CGPoint { get }

    func activate()
}

protocol TogglePowerup: Powerup {
    var duration: Double { get }

    func deactivate()
}
