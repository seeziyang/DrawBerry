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
    var drawingViews: [CompetitivePlayer: CompetitiveVotingView] = [:]
    var currentGame = CompetitiveGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        addVotingViews()
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

                let drawingView = CompetitiveVotingView(frame: rect, listOfDrawings: drawingList,
                                                        listOfPlayers: currentGame.players,
                                                        currentPlayer: currentGame.players[playerNum])
                for drawing in drawingView.drawings {
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                    drawing.addGestureRecognizer(tapGesture)
                    drawing.isUserInteractionEnabled = true
                }

                if playerNum < 2 {
                    drawingView.transform = drawingView.transform.rotated(by: CGFloat.pi)
                }

                self.view.addSubview(drawingView)
                drawingViews[currentGame.players[playerNum]] = drawingView

                playerNum += 1
            }
        }
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

    private func vote(with players: [CompetitivePlayer], _ playerWhoVoted: CompetitivePlayer,
                      _ playerVotedFor: CompetitivePlayer) {
        guard let playerVotingView = drawingViews[playerWhoVoted] else {
            return
        }

        if playerWhoVoted.votesLeft <= 0 {
            playerVotingView.updateText(to: Message.competitiveVotingUsedAllVotes)
            return
        } else if playerWhoVoted == playerVotedFor {
            playerVotingView.updateText(to: Message.competitiveVotingCannotSelfVote)
            return
        } else if playerWhoVoted.hasVotedFor.contains(playerVotedFor) {
            playerVotingView.updateText(to: Message.competitiveVotingAlreadyVoted)
            return
        }

        playerVotingView.updateText(to: "You gave \(playerWhoVoted.votesLeft) vote(s) " +
            "to \(playerVotedFor.name)")

        playerVotedFor.votesGiven += playerWhoVoted.votesLeft
        playerWhoVoted.hasVotedFor.insert(playerVotedFor)
        playerWhoVoted.votesLeft -= 1

        checkAllPlayersDoneVoting()
    }

    private func checkAllPlayersDoneVoting() {
        if currentGame.players.map({ $0.isDoneVoting }).allSatisfy({ $0 == true }) {
            currentGame.nextRound()

            if currentGame.isGameOver {
                // TODO: Rankings screen?
                performSegue(withIdentifier: "segueToMainMenu", sender: self)
            } else {
                collateVotes()
                currentGame.players.forEach { $0.resetVotes() }
                showNextButtons()
            }
        }
    }

    private func collateVotes() {
        let sortedPlayers = currentGame.players.sorted(by: { $0.votesGiven > $1.votesGiven })

        var numberOfPlayersWithSimilarVotes = 0
        for i in 0...1 {
            let currentIndex = i + numberOfPlayersWithSimilarVotes
            if currentIndex >= sortedPlayers.count {
                break
            }

            let numberOfVotes = sortedPlayers[currentIndex].votesGiven
            let artist = sortedPlayers[currentIndex]

            if i == 0 {
                giveFirstPlaceMedal(to: artist)
                artist.score += CompetitiveGame.FIRST_PLACE_SCORE
            } else {
                giveSecondPlaceMedal(to: artist)
                artist.score += CompetitiveGame.SECOND_PLACE_SCORE
            }

            // Find players with similar votecount as previous artist
            while true {
                numberOfPlayersWithSimilarVotes += 1
                let nextIndex = i + numberOfPlayersWithSimilarVotes

                if nextIndex < sortedPlayers.count && sortedPlayers[nextIndex].votesGiven == numberOfVotes {
                    let nextArtist = sortedPlayers[nextIndex]
                    if i == 0 {
                        giveFirstPlaceMedal(to: nextArtist)
                        nextArtist.score += CompetitiveGame.FIRST_PLACE_SCORE
                    } else {
                        giveSecondPlaceMedal(to: nextArtist)
                        nextArtist.score += CompetitiveGame.SECOND_PLACE_SCORE
                    }
                } else {
                    numberOfPlayersWithSimilarVotes -= 1
                    break
                }
            }
        }

        disableVoting()
        updateVotingFinishedText()
    }

    private func giveFirstPlaceMedal(to artist: CompetitivePlayer) {
        for view in drawingViews.values {
            for drawing in view.drawings where drawing.drawingArtist == artist {
                drawing.addFirstPlaceMedal()
            }
        }
    }

    private func giveSecondPlaceMedal(to artist: CompetitivePlayer) {
        for view in drawingViews.values {
            for drawing in view.drawings where drawing.drawingArtist == artist {
                    drawing.addSecondPlaceMedal()
            }
        }
    }

    private func disableVoting() {
        for view in drawingViews.values {
            for drawing in view.drawings {
                drawing.gestureRecognizers?.forEach { $0.isEnabled = false }
            }
        }
    }

    private func updateVotingFinishedText() {
        drawingViews.values.forEach { $0.updateText(to: Message.competitiveVotingResult) }
    }

    private func showNextButtons() {
        for view in drawingViews.values {
            let nextButtonImageView = UIImageView(image: CompetitiveGame.NEXT_BUTTON)

            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapNextButton(_:)))
            nextButtonImageView.addGestureRecognizer(tap)
            nextButtonImageView.isUserInteractionEnabled = true

            view.addNextButton(nextButtonImageView)
            view.isUserInteractionEnabled = true
        }
    }

    var playersReady = 0
    @objc func handleTapNextButton(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        playersReady += 1

        if playersReady == currentGame.players.count {
            performSegue(withIdentifier: "segueToNextCompetitiveRound", sender: self)
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
