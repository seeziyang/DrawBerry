//
//  DrawOutOfBoundsPowerup.swift
//  DrawBerry
//
//  Created by Jon Chua on 19/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class InkSplotchPowerup: Powerup {
    var image = PowerupAssets.inksplotchPowerupUIImage

    var owner: CompetitivePlayer
    var targets: [CompetitivePlayer]
    var location: CGPoint

    var description = "Ink Splotch!"

    required init(owner: CompetitivePlayer, players: [CompetitivePlayer], location: CGPoint) {
        self.owner = owner
        self.targets = players.filter { $0 != owner }
        self.location = location
    }

    func activate() {
        for target in targets {
            let inkSplotch = UIImageView(image: PowerupAssets.inkSplotchUIImage)

            let randomWidth = CGFloat.random(in: 100...400)
            let randomHeight = CGFloat.random(in: 100...400)

            inkSplotch.frame = CGRect(x: .random(in: 0...target.canvasDrawing.bounds.maxX - randomWidth),
                                      y: .random(in: 0...target.canvasDrawing.bounds.maxY - randomHeight),
                                      width: randomWidth, height: randomHeight)

            target.canvasDrawing.addSubview(inkSplotch)
            target.canvasDrawing.bringSubviewToFront(inkSplotch)
        }
    }
}
