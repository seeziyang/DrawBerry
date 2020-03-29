//
//  PlayerCollectionViewCell.swift
//  DrawBerry
//
//  Created by Calvin Chen on 28/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class PlayerCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!

    func setCircularShape() {
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.height
        profileImageView.clipsToBounds = true
    }

    func setDefaultImage() {
        let testImage = #imageLiteral(resourceName: "grey")
        let size = frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            testImage.draw(in: CGRect(origin: .zero, size: size))
        }
        profileImageView.image = image
    }

    func setUsername(_ text: String) {
        usernameLabel.text = text
    }
}

extension PlayerCollectionViewCell: UserProfileNetworkDelegate {

    func loadProfileImage(image: UIImage?) {
        guard let image = image else {
            setDefaultImage()
            return
        }

        let size = frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        profileImageView.image = resizedImage
    }

}
