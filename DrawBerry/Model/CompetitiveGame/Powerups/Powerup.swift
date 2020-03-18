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
    var targets: [CompetitivePlayer] { get set }
    var location: CGPoint { get set }

    func activate()
}

protocol TogglePowerup: Powerup {
    var duration: Double { get set }

    func deactivate()
}
