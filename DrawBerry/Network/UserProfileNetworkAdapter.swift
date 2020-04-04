//
//  UserProfileNetworkAdapter.swift
//  DrawBerry
//
//  Created by Calvin Chen on 29/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FirebaseStorage

class UserProfileNetworkAdapter {
    static let db = Database.database().reference()
    static let cloud = Storage.storage().reference()
    static var delegate: UserProfileNetworkDelegate?
    static var storageListResult: StorageListResult?

    static func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.3),
            let userID = NetworkHelper.getLoggedInUserID() else {
                return
        }

        let cloudPathRef = cloud.child("users").child(userID).child(Constants.profilePictureFileName)

        cloudPathRef.putData(imageData, metadata: nil, completion: { _, error in
            if let error = error {
                print("Error \(error) occured while uploading to CloudStorage")
                return
            }

        })
    }

    // TODO: add function after game ends
    static func uploadImageToFavourites(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.3),
            let userID = NetworkHelper.getLoggedInUserID() else {
                return
        }

        let fileExtension = ".jpeg"
        let fileName = StringHelper.getCurrentDateTime()

        let cloudPathRef = cloud.child("users").child(userID).child("gallery").child(fileName + fileExtension)

        cloudPathRef.putData(imageData, metadata: nil, completion: { _, error in
            if let error = error {
                print("Error \(error) occured while uploading to CloudStorage")
                return
            }

        })
    }

    static func downloadProfileImage(delegate: UserProfileNetworkDelegate, playerUID: String?) {
        guard let playerUID = playerUID else {
            return
        }

        let cloudPathRef = cloud.child("users").child(playerUID).child(Constants.profilePictureFileName)

        cloudPathRef.getData(maxSize: 1 * 1_024 * 1_024, completion: { data, error in
            if let error = error {
                print("Error \(error) occured while downloading player profile")
                delegate.loadImage(image: nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Error occured while converting player profile")
                delegate.loadImage(image: nil)
                return
            }

            delegate.loadImage(image: image)
        })
    }

    static func getListOfImages(delegate: UserProfileViewController, playerUID: String) {
        cloud.child("users").child(playerUID).child("gallery").listAll(completion: { result, error in
            if let error = error {
                print("Error \(error) occured while downloading player profile")
                return
            }

            storageListResult = result
            delegate.reloadData()

        })
    }

    static func downloadImage(delegate: UserProfileNetworkDelegate, index: Int) {

        guard let result = storageListResult else {
            return
        }

        if index >= result.items.count {
            return
        }

        let item = result.items[index]

        item.getData(maxSize: 1 * 1_024 * 1_024, completion: { data, error in
            if let error = error {
                print("Error \(error) occured while downloading image")
                delegate.loadImage(image: nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                delegate.loadImage(image: nil)
                return
            }

            delegate.loadImage(image: image)
        })
    }
}
