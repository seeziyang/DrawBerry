//
//  ImageCollectionViewCell.swift
//  DrawBerry
//
//  Created by Calvin Chen on 30/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func setImage(image: UIImage) {

        let size = frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        imageView.image = resizedImage
    }

}
