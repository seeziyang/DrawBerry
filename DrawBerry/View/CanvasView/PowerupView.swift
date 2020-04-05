//
//  PowerupView.swift
//  DrawBerry
//
//  Created by Jon Chua on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class PowerupView: UIImageView {
    let coordinates: CGPoint

    init(image: UIImage?, coordinates: CGPoint) {
        self.coordinates = coordinates
        super.init(image: image)
    }

    required init?(coder: NSCoder) {
        nil
    }
}
