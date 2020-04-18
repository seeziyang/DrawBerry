//
//  VotingViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class VotingViewController: UIViewController, ClassicGameDelegate {
    var classicGame: ClassicGame!

    @IBOutlet private weak var votingImagesCollectionView: UICollectionView!

    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var itemsPerRow: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light

        let minIPadWidth: CGFloat = 768
        // 2 for iPad, 1 for iPhone
        itemsPerRow = view.bounds.maxX >= minIPadWidth ? 2 : 1
    }

    func drawingsDidUpdate() {
        votingImagesCollectionView.reloadData()
        // TODO: show spinning wheel or some loading indicator if player havent upload
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let voteResultsVC = segue.destination as? VoteResultsViewController {
            classicGame.delegate = voteResultsVC
            classicGame.observePlayerVotes()
            if !(classicGame is NonRapidClassicGame) &&
                    !classicGame.userIsNextRoundMaster() {
                classicGame.observeNextRoundTopic()
            }

            voteResultsVC.classicGame = classicGame
        } else if let classicVC = segue.destination as? ClassicViewController {
            classicVC.classicGame = classicGame
        }
    }

    @objc private func handleDrawingTap(_ sender: UITapGestureRecognizer) {
        if classicGame.hasAllPlayersDrawnForCurrentRound() {
            guard let cell = sender.view as? UICollectionViewCell else {
                return
            }

            guard let indexPath = votingImagesCollectionView.indexPath(for: cell) else {
                return
            }

            let player = classicGame.players[indexPath.row]

            if player === classicGame.user {
                // TODO: show msg saying user cannot vote for themself
                return
            }

            voteForPlayerDrawing(player: player)
        } else {
            // TODO: show msg saying not all players have drawn
        }
    }

    private func voteForPlayerDrawing(player: ClassicPlayer) {
        if !(classicGame is NonRapidClassicGame)
                && classicGame.userIsNextRoundMaster()
                && !classicGame.isLastRound {
            let nextRound = classicGame.currentRound + 1
            let alert = AlertHelper.makeInputAlert(
                title: "Enter topic for the next round",
                message: "You are the round master for Round \(nextRound)",
                placeholder: "Topic for Round \(nextRound)",
                handler: { [weak self] topic in
                    self?.classicGame.addNextRoundTopic(topic)
                    self?.classicGame.userVoteFor(player: player)
                    self?.segueToNextScreen()
                }
            )
            present(alert, animated: true)
        } else {
            classicGame.userVoteFor(player: player)
            segueToNextScreen()
        }
    }

    private func segueToNextScreen() {
        if classicGame is NonRapidClassicGame {
            performSegue(withIdentifier: "segueToDrawing", sender: self)
        } else {
            performSegue(withIdentifier: "segueToVoteResults", sender: self)
        }
    }
}

extension VotingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        classicGame.players.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "votingImageCell", for: indexPath)

        let imageView = UIImageView(frame: cell.bounds)

        if classicGame is NonRapidClassicGame {
            imageView.image = classicGame.players[indexPath.row].getDrawingImage()
        } else {
            imageView.image = classicGame.players[indexPath.row]
                .getDrawingImage(ofRound: classicGame.currentRound)
        }

        imageView.contentMode = .scaleAspectFit

        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.addSubview(imageView)
        cell.backgroundView = UIImageView(image: #imageLiteral(resourceName: "paper-brown"))

        addTapGesture(cell: cell)

        return cell
    }

    private func addTapGesture(cell: UICollectionViewCell) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleDrawingTap(_:)))
        cell.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension VotingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * Constants.votingCellHeightRatio

        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
}
