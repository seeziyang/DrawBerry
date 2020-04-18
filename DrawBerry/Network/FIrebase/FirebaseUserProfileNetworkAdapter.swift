//
//  UserProfileNetworkAdapter.swift
//  DrawBerry
//
//  Created by Calvin Chen on 29/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FirebaseStorage

class FirebaseUserProfileNetworkAdapter: UserProfileNetwork {
    let db: DatabaseReference
    let cloud: StorageReference
    var storageListResult: StorageListResult?

    init() {
        self.db = Database.database().reference()
        self.cloud = Storage.storage().reference()
    }

    /// Uploads the profile image of a player
    func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.3), let userID = getLoggedInUserID() else {
                return
        }

        let cloudPathRef = cloud.child("users").child(userID).child(Constants.profilePictureFileName)
        uploadDataToDatabase(data: imageData, reference: cloudPathRef)
    }

    // TODO: add function after game ends
    /// Uploads the image in the to the player's gallery
    func uploadImageToFavourites(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.3), let userID = getLoggedInUserID() else {
                return
        }

        let fileExtension = ".jpeg"
        let fileName = StringHelper.getCurrentDateTime()
        let cloudPathRef = cloud.child("users").child(userID).child("gallery").child(fileName + fileExtension)

        uploadDataToDatabase(data: imageData, reference: cloudPathRef)

    }

    /// Loads the profile image in the `UserProfileNetworkDelegate`
    func downloadProfileImage(delegate: UserProfileNetworkDelegate, playerUID: String?) {
        guard let playerUID = playerUID else {
            return
        }

        let cloudPathRef = cloud.child("users").child(playerUID).child(Constants.profilePictureFileName)
        downloadDataFromDatabase(reference: cloudPathRef, delegate: delegate)
    }

    /// Loads all images of a player's gallery in the `UserProfileViewController`
    func getListOfImages(delegate: UserProfileViewController, playerUID: String) {
        storageListResult = nil

        cloud.child("users").child(playerUID).child("gallery")
            .listAll(completion: { [weak self] result, error in
                if let error = error {
                    print("Error \(error) occured while downloading player profile")
                    return
                }

                self?.storageListResult = result
                delegate.reloadData()
            })
    }

    /// Loads the drawing image in the `UserProfileNetworkDelegate`
    func downloadImage(delegate: UserProfileNetworkDelegate, index: Int) {

        guard let result = storageListResult else {
            return
        }

        if index >= result.items.count {
            return
        }

        let cloudPathRef = result.items[index]
        downloadDataFromDatabase(reference: cloudPathRef, delegate: delegate)
    }

    /// Uploads image data to database
    func uploadDataToDatabase(data: Data, reference: StorageReference) {
        reference.putData(data, metadata: nil, completion: { _, error in
            if let error = error {
                print("Error \(error) occured while uploading to CloudStorage")
                return
            }
        })
    }

    /// Downloads image data from database
    func downloadDataFromDatabase(reference: StorageReference,
                                  delegate: UserProfileNetworkDelegate) {
        reference.getData(maxSize: 1 * 1_024 * 1_024, completion: { data, error in
            if let error = error {
                print("Error \(error) occured while downloading data")
                delegate.loadImage(image: nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Error occured during data conversion")
                delegate.loadImage(image: nil)
                return
            }

            delegate.loadImage(image: image)
        })
    }
}
