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
    private var statusViewLabel = UITextView()
    private var infoViewLabel = UITextView()

    private var powerupViews = Set<PowerupView>()

    func setupViews(name: String, currentRound: Int, maxRounds: Int, score: Int) {
        setupTimeLeftText()
        setupStatusView()
        setupPlayerInfoView(name, currentRound, maxRounds, score)
    }

    private func setupTimeLeftText() {
        let width = 200, height = 200, size = 120, resultFont = "MarkerFelt-Thin"

        timeLeftLabel = UITextView(frame: CGRect(x: bounds.midX - CGFloat(width / 2),
                                                 y: bounds.midY - CGFloat(height / 2),
                                                 width: CGFloat(width), height: CGFloat(height)),
                                   textContainer: nil)
        timeLeftLabel.font = UIFont(name: resultFont, size: CGFloat(size))
        timeLeftLabel.textAlignment = NSTextAlignment.center
        timeLeftLabel.text = String(CompetitiveGame.TIME_PER_ROUND)
        timeLeftLabel.backgroundColor = UIColor.clear
        timeLeftLabel.isUserInteractionEnabled = false
        timeLeftLabel.alpha = 0.4

        addSubview(timeLeftLabel)
    }

    private func setupStatusView() {
        let width = 800, height = 200, size = 40, resultFont = "MarkerFelt-Thin"

        statusViewLabel = UITextView(frame: CGRect(x: bounds.midX - CGFloat(width / 2), y: 50,
                                                   width: CGFloat(width), height: CGFloat(height)),
                                     textContainer: nil)
        statusViewLabel.font = UIFont(name: resultFont, size: CGFloat(size))
        statusViewLabel.textAlignment = NSTextAlignment.center
        statusViewLabel.text = ""
        statusViewLabel.backgroundColor = UIColor.clear
        statusViewLabel.isUserInteractionEnabled = false
        statusViewLabel.alpha = 0.0

        addSubview(statusViewLabel)
    }

    private func setupPlayerInfoView(_ name: String, _ currentRound: Int, _ maxRounds: Int, _ score: Int) {
        let width = 800, height = 200, size = 20, resultFont = "MarkerFelt-Thin"

        infoViewLabel = UITextView(frame: CGRect(x: 10, y: 5, width: CGFloat(width), height: CGFloat(height)),
                                   textContainer: nil)
        infoViewLabel.font = UIFont(name: resultFont, size: CGFloat(size))
        infoViewLabel.textAlignment = NSTextAlignment.left
        infoViewLabel.text = "\(name): Round \(currentRound) of \(maxRounds)\nScore: \(score)"
        infoViewLabel.backgroundColor = UIColor.clear
        infoViewLabel.isUserInteractionEnabled = false
        infoViewLabel.alpha = 0.6

        addSubview(infoViewLabel)
    }

    func animateStatus(with text: String) {
        statusViewLabel.text = text
        statusViewLabel.alpha = 0.6
        statusViewLabel.setNeedsDisplay()

        UITextView.animate(withDuration: 1.0) {
            self.statusViewLabel.alpha = 0.0
        }
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

    func addNextButton(_ button: UIImageView) {
        button.frame = CGRect(x: bounds.maxX - 70, y: bounds.maxY - 100, width: 50, height: 50)

        addSubview(button)
        bringSubviewToFront(button)
    }
}
