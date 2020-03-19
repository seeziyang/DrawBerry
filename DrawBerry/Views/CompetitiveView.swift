//
//  CompetitiveView.swift
//  DrawBerry
//
//  Created by Jon Chua on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveView: UIView {
    private var timeLeftLabel = UITextView()
    private var powerupViews = Set<PowerupView>()

    func setupViews() {
        setupTimeLeftText()
    }

    private func setupTimeLeftText() {
        let width = 200, height = 200, size = 120, resultFont = "MarkerFelt-Thin"

        timeLeftLabel = UITextView(
            frame: CGRect(x: bounds.midX - CGFloat(width / 2), y: bounds.midY - CGFloat(height / 2),
                          width: CGFloat(width), height: CGFloat(height)), textContainer: nil)
        timeLeftLabel.font = UIFont(name: resultFont, size: CGFloat(size))
        timeLeftLabel.textAlignment = NSTextAlignment.center
        timeLeftLabel.text = String(CompetitiveGame.TIME_PER_ROUND)
        timeLeftLabel.backgroundColor = UIColor.clear
        timeLeftLabel.isUserInteractionEnabled = false
        timeLeftLabel.alpha = 0.4

        addSubview(timeLeftLabel)
    }

    func updateTimeLeftText(to text: String) {
        timeLeftLabel.text = text
        timeLeftLabel.setNeedsDisplay()
    }

    func addPowerupToView(_ powerup: Powerup) {
            let powerupImage = PowerupView(image: powerup.image, coordinates: powerup.location)
            powerupImage.frame = CGRect(x: powerup.location.x, y: powerup.location.y,
                                        width: PowerupManager.POWERUP_RADIUS * 2,
                                        height: PowerupManager.POWERUP_RADIUS * 2)
            powerupViews.insert(powerupImage)
            addSubview(powerupImage)
    }

    func removePowerupFromView(_ powerup: Powerup) {
        let coordinates = powerup.location
        for powerupView in powerupViews where powerupView.coordinates == coordinates {
            powerupView.removeFromSuperview()
            powerupViews.remove(powerupView)
        }
    }
}
