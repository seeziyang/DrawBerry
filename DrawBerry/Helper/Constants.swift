//
//  Constants.swift
//  DrawBerry
//
//  Created by Calvin Chen on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

enum Constants {
    static let background = #imageLiteral(resourceName: "background")
    static let loginBackground = background
    static let signUpBackground = background
    static let mainMenuBackground = background
    static let roomBackground = background
    static let logo = #imageLiteral(resourceName: "drawberry-logo")
    static let defaultProfilePicture = #imageLiteral(resourceName: "grey")

    static let backgroundAlpha = CGFloat(0.7)

    static let profilePictureFileName = "profile.jpeg"

    static let votingCellHeightRatio: CGFloat = 1.5

    static let errorLabelColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.3803921569, alpha: 1)
}
