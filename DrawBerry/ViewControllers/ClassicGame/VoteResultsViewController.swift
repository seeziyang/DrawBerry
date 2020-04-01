//
//  VoteResultsViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 31/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class VoteResultsViewController: UIViewController, ClassicGameDelegate {
    var classicGame: ClassicGame!

    @IBOutlet private weak var voteResultsCollectionView: UICollectionView!

    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var itemsPerRow: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light

        let minIPadWidth: CGFloat = 768
        // 2 for iPad, 1 for iPhone
        itemsPerRow = view.bounds.maxX >= minIPadWidth ? 2 : 1
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let classicVC = segue.destination as? ClassicViewController {
            classicVC.classicGame = classicGame
        }
    }

    func votesDidUpdate() {
        voteResultsCollectionView.reloadData()
    }

    func segueToNextRound() {
        performSegue(withIdentifier: "segueToNextRound", sender: self)
    }
}

extension VoteResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        classicGame.players.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "voteResultCell", for: indexPath
        ) as? VoteResultCollectionViewCell else {
            fatalError("Unable to get reusable cell.")
        }

        let player = classicGame.players[indexPath.row]

        cell.backgroundColor = player === classicGame.roundMaster ? .systemOrange : .systemYellow

        cell.setDrawingImage(player.getDrawingImage(ofRound: classicGame.currentRound))
        cell.setName(player.name)
        cell.setPoints(player.points)

        return cell
    }
}

extension VoteResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * 1.5

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
