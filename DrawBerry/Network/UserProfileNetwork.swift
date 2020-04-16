//
//  UserProfileNetwork.swift
//  DrawBerry
//
//  Created by See Zi Yang on 14/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol UserProfileNetwork {
    func uploadProfileImage(_ image: UIImage)

    func uploadImageToFavourites(_ image: UIImage)

    func downloadProfileImage(delegate: UserProfileNetworkDelegate, playerUID: String?)

    func getListOfImages(delegate: UserProfileViewController, playerUID: String)

    func downloadImage(delegate: UserProfileNetworkDelegate, index: Int)
}
