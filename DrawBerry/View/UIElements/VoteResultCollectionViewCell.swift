//
//  VoteResultCollectionViewCell.swift
//  DrawBerry
//
//  Created by See Zi Yang on 31/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class VoteResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var drawingImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var pointsLabel: UILabel!

    func setDrawingImage(_ image: UIImage?) {
        drawingImageView.image = image
        drawingImageView.contentMode = .scaleAspectFit
        contentView.sendSubviewToBack(backgroundImageView)
    }

    func setName(_ name: String) {
        nameLabel.text = name
    }

    func setPoints(_ points: Int) {
        pointsLabel.text = String(points)
    }
}
