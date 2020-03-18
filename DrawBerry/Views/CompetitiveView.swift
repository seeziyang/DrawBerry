//
//  CompetitiveView.swift
//  DrawBerry
//
//  Created by Jon Chua on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveView: UIView {
    var timeLeftLabel = UITextView()
    var powerupViews = [PowerupView]()

    func setupViews() {
        setupTimeLeftText()
    }

    private func setupTimeLeftText() {
        let resultWidth = 200, resultHeight = 200, resultSize = 120, resultFont = "MarkerFelt-Thin"

        timeLeftLabel = UITextView(
            frame: CGRect(x: bounds.midX - CGFloat(resultWidth / 2), y: bounds.midY - CGFloat(resultHeight / 2),
                          width: CGFloat(resultWidth), height: CGFloat(resultHeight)),
            textContainer: nil)
        timeLeftLabel.font = UIFont(name: resultFont, size: CGFloat(resultSize))
        timeLeftLabel.textAlignment = NSTextAlignment.center
        timeLeftLabel.text = String(CompetitiveGame.TIME_PER_ROUND)
        timeLeftLabel.backgroundColor = UIColor.clear
        timeLeftLabel.isUserInteractionEnabled = false

        addSubview(timeLeftLabel)
    }

    func updateTimeLeftText(to text: String) {
        timeLeftLabel.text = text
        timeLeftLabel.setNeedsDisplay()
    }

    func addPowerups(_ powerups: [Powerup]) {
        for powerup in powerups {
            let powerupImage = PowerupView(image: powerup.image, coordinates: powerup.location)
            powerupImage.frame = CGRect(x: powerup.location.x, y: powerup.location.y,
                                        width: CGFloat(PowerupManager.POWERUP_RADIUS),
                                        height: CGFloat(PowerupManager.POWERUP_RADIUS))
            powerupViews.append(powerupImage)
            addSubview(powerupImage)
        }
    }

    func removePowerups(_ powerups: [Powerup]) {
        // MARK: TODO
    }
}
