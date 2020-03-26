//
//  Powerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol Powerup {
    var image: UIImage { get }

    var owner: CompetitivePlayer { get }
    var targets: [CompetitivePlayer] { get }
    var location: CGPoint { get }

    var description: String { get }

    func activate()

    init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint)
}

protocol TogglePowerup: Powerup {
    var duration: Double { get }

    func deactivate()
}
