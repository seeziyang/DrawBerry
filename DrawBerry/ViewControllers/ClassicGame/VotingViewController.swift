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

        let minIPadWidth: CGFloat = 768
        // 2 for iPad, 1 for iPhone
        itemsPerRow = view.bounds.maxX >= minIPadWidth ? 2 : 1
        overrideUserInterfaceStyle = .light
    }

    func drawingsDidUpdate() {
        votingImagesCollectionView.reloadData()
        // TODO: reload specific player's image only?
        // TODO: show spinning wheel or some loading indicator if player havent upload
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
        imageView.image = classicGame.players[indexPath.row]
            .getDrawingImage(ofRound: classicGame.currentRound)
        imageView.contentMode = .scaleAspectFit

        cell.addSubview(imageView)
        cell.backgroundColor = .systemYellow // TODO: remove
        return cell
    }
}

extension VotingViewController: UICollectionViewDelegateFlowLayout {
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
