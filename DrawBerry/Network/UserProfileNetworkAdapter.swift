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

    static func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            return
        }

        let userID = NetworkHelper.getLoggedInUserID()

        //print(userID)

//        let dbPathRef = db.child("users").child(userID).child("profilePicture")
//
//        //dbPathRef.setValue(true)

        let cloudPathRef = cloud.child("users").child(userID).child(Constants.profilePictureFileName)

        cloudPathRef.putData(imageData, metadata: nil, completion: { _, error in
            if let error = error {
                print("Error \(error) occured while uploading to CloudStorage")
                return
            }

        })
    }

    static func downloadProfileImage(delegate: UserProfileNetworkDelegate, playerUID: String) {

        let cloudPathRef = cloud.child("users").child(playerUID).child(Constants.profilePictureFileName)

        cloudPathRef.getData(maxSize: 1 * 1_024 * 1_024, completion: { data, error in
            if let error = error {
                print("Error \(error) occured while downloading player profile")
                delegate.loadProfileImage(image: nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Error occured while converting player profile")
                delegate.loadProfileImage(image: nil)
                return
            }

            delegate.loadProfileImage(image: image)
        })
    }

}
