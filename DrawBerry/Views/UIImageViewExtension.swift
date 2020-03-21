//
//  UIViewExtension.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

extension UIImageView {
    var withoutStatusBar: UIView? {
        let imageView = UIImageView(image: self.image)
        let image = imageView.image?.removingStatusBar
        imageView.image = image
        return imageView
    }
}
