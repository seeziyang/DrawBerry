//
//  CompetitiveVotingViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 2/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CompetitiveVotingViewController: UIViewController {
    var drawingList = [UIImage]()
    var drawingViews = [UIView]()
    var currentGame = CompetitiveGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        addVotingViews()
        addVotingText()
    }

    private func addVotingText() {
        for view in drawingViews {
            let width = 200, height = 250, size = 30, resultFont = "MarkerFelt-Thin"

            let textLabel = UITextView(frame: CGRect(x: view.bounds.midX - CGFloat(width / 2),
                                                     y: view.bounds.midY - CGFloat(height / 2),
                                                     width: CGFloat(width), height: CGFloat(height)),
                                       textContainer: nil)
            textLabel.font = UIFont(name: resultFont, size: CGFloat(size))
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.text = "Voting time!\n\nVote for who you think drew the best two drawings."
            textLabel.backgroundColor = UIColor.clear
            textLabel.isUserInteractionEnabled = false
            textLabel.alpha = 0.4

            view.addSubview(textLabel)
        }
    }

    /// Adds the four voting views for each player to vote.
    private func addVotingViews() {
        assert(drawingList.count == 4, "Player count should be 4")

        let defaultSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height / 2)

        let minX = self.view.bounds.minX
        let maxX = self.view.bounds.maxX
        let minY = self.view.bounds.minY
        let maxY = self.view.bounds.maxY

        var playerNum = 0

        for y in stride(from: minY, to: maxY, by: (maxY + minY) / 2) {
            for x in stride(from: minX, to: maxX, by: (maxX + minX) / 2) {
                let rect = CGRect(origin: CGPoint(x: x, y: y), size: defaultSize)
                let drawingView = getAllDrawingsFitToFrame(currentPlayer: playerNum, frame: rect)

                if playerNum < 2 {
                    drawingView.transform = drawingView.transform.rotated(by: CGFloat.pi)
                }

                self.view.addSubview(drawingView)
                drawingViews.append(drawingView)

                playerNum += 1
            }
        }
    }

    /// Returns a UIView of all four player's drawings for the `currentPlayer`, sized to fit the specified `frame`
    private func getAllDrawingsFitToFrame(currentPlayer: Int, frame: CGRect) -> UIView {
        let resultView = UIView(frame: frame)

        let backgroundImage = UIImageView(frame: resultView.bounds)
        backgroundImage.image = BerryConstants.paperBackgroundImage
        resultView.addSubview(backgroundImage)

        let defaultSize = CGSize(width: resultView.bounds.width / 2, height: resultView.bounds.height / 2)

        let minX = resultView.bounds.minX
        let maxX = resultView.bounds.maxX
        let minY = resultView.bounds.minY
        let maxY = resultView.bounds.maxY

        var playerNum = 0

        for y in stride(from: minY, to: maxY, by: (maxY + minY) / 2) {
            for x in stride(from: minX, to: maxX, by: (maxX + minX) / 2) {
                let rect = CGRect(origin: CGPoint(x: x, y: y), size: defaultSize)

                let playerDrawing = DrawingView(player: currentPlayer, drawingArtist: playerNum, frame: rect)
                playerDrawing.image = drawingList[playerNum]

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                playerDrawing.addGestureRecognizer(tapGesture)
                playerDrawing.isUserInteractionEnabled = true

                resultView.addSubview(playerDrawing)

                playerNum += 1
            }
        }

        return resultView
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? DrawingView else {
            return
        }

        let players = currentGame.players
        let playerWhoVoted = tappedView.player
        let playerVotedFor = tappedView.drawingArtist

        vote(with: players, playerWhoVoted, playerVotedFor)
    }

    private func vote(with players: [CompetitivePlayer], _ playerWhoVoted: Int, _ playerVotedFor: Int) {
        if players[playerWhoVoted].votesLeft <= 0 {
            // Cannot vote anymore
            print("Cannot vote anymore")
            return
        } else if playerWhoVoted == playerVotedFor {
            // Player cannot vote for themselves
            print("Cannot vote for themselves")
            return
        } else if players[playerWhoVoted].hasVotedFor.contains(players[playerVotedFor]) {
            // This player has already voted for that player
            print("Has already voted")
            return
        }

        print("Player \(playerWhoVoted) voted for Player \(playerVotedFor)")
        players[playerVotedFor].votesGiven += players[playerWhoVoted].votesLeft
        players[playerWhoVoted].hasVotedFor.insert(players[playerVotedFor])
        players[playerWhoVoted].votesLeft -= 1

        // Check if all players done voting
        if players.map({ $0.isDoneVoting }).allSatisfy({ $0 == true }) {
            currentGame.nextRound()

            if currentGame.isGameOver {
                // TODO: Rankings screen?
                performSegue(withIdentifier: "segueToMainMenu", sender: self)
            } else {
                // TODO: Show best voted drawing before segue to next round
                currentGame.players.forEach { $0.resetVotes() }
                performSegue(withIdentifier: "segueToNextCompetitiveRound", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let competitiveVC = segue.destination as? CompetitiveViewController {
            competitiveVC.competitiveGame = currentGame

            // TODO: Extension for best drawing?
        }
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}

class DrawingView: UIImageView {
    let player: Int
    let drawingArtist: Int

    init(player: Int, drawingArtist: Int, frame: CGRect) {
        self.player = player
        self.drawingArtist = drawingArtist
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        nil
    }
}
