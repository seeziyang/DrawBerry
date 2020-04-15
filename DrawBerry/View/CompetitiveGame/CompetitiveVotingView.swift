//
//  CompetitiveVotingView.swift
//  DrawBerry
//
//  Created by Jon Chua on 3/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveVotingView: UIView {
    var listOfDrawings: [UIImage]
    var listOfPlayers: [CompetitivePlayer]
    var currentPlayer: CompetitivePlayer

    var drawings = [DrawingView]()

    var votingTextLabel = UITextView()

    init(frame: CGRect, listOfDrawings: [UIImage],
         listOfPlayers: [CompetitivePlayer], currentPlayer: CompetitivePlayer) {
        self.listOfDrawings = listOfDrawings
        self.listOfPlayers = listOfPlayers
        self.currentPlayer = currentPlayer

        super.init(frame: frame)

        addBackground()
        addDrawings()
        addVotingText()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func addBackground() {
        let backgroundImage = UIImageView(frame: bounds)
        backgroundImage.image = BerryConstants.paperBackgroundImage
        addSubview(backgroundImage)
    }

    private func addDrawings() {
        let defaultSize = CGSize(width: bounds.width / 2, height: bounds.height / 2)
        let minX = bounds.minX, maxX = bounds.maxX, minY = bounds.minY, maxY = bounds.maxY

        var playerNum = 0

        for y in stride(from: minY, to: maxY, by: (maxY + minY) / 2) {
            for x in stride(from: minX, to: maxX, by: (maxX + minX) / 2) {
                let rect = CGRect(origin: CGPoint(x: x, y: y), size: defaultSize)

                let playerDrawing = DrawingView(player: currentPlayer,
                                                drawingArtist: listOfPlayers[playerNum], frame: rect)
                playerDrawing.image = listOfDrawings[playerNum]

                addSubview(playerDrawing)
                drawings.append(playerDrawing)

                playerNum += 1
            }
        }
    }

    private func addVotingText() {
        let width = 200, height = 250, size = 30, resultFont = "MarkerFelt-Thin"

        votingTextLabel = UITextView(frame: CGRect(x: bounds.midX - CGFloat(width / 2),
                                                   y: bounds.midY - CGFloat(height / 2),
                                                   width: CGFloat(width), height: CGFloat(height)),
                                   textContainer: nil)
        votingTextLabel.font = UIFont(name: resultFont, size: CGFloat(size))
        votingTextLabel.textAlignment = NSTextAlignment.center
        votingTextLabel.text = Message.competitiveVotingTime
        votingTextLabel.backgroundColor = UIColor.clear
        votingTextLabel.isUserInteractionEnabled = false
        votingTextLabel.alpha = 0.4

        addSubview(votingTextLabel)
    }

    func updateText(to text: String) {
        votingTextLabel.text = text
        votingTextLabel.setNeedsDisplay()
    }

    func showResultText(text: String) {
        votingTextLabel.alpha = 0.8
        votingTextLabel.text = text
    }

    func addNextButton(_ button: UIImageView) {
        button.frame = CGRect(x: bounds.maxX - 70, y: bounds.maxY - 100, width: 50, height: 50)

        addSubview(button)
        bringSubviewToFront(button)
    }
}

class DrawingView: UIImageView {
    let player: CompetitivePlayer
    let drawingArtist: CompetitivePlayer

    init(player: CompetitivePlayer, drawingArtist: CompetitivePlayer, frame: CGRect) {
        self.player = player
        self.drawingArtist = drawingArtist
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        nil
    }

    func addFirstPlaceMedal() {
        let image = #imageLiteral(resourceName: "first-medal")
        let imageView = UIImageView(frame: CGRect(x: 10, y: 15, width: 60, height: 60))
        imageView.image = image

        addSubview(imageView)
        bringSubviewToFront(imageView)
    }

    func addSecondPlaceMedal() {
        let image = #imageLiteral(resourceName: "second-medal")
        let imageView = UIImageView(frame: CGRect(x: 10, y: 15, width: 60, height: 60))
        imageView.image = image

        addSubview(imageView)
        bringSubviewToFront(imageView)
    }
}
