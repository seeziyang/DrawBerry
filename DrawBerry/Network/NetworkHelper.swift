//
//  NetworkHelper.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

struct NetworkHelper {

    static func getLoggedInUserID() -> String? {
        Auth.auth().currentUser?.uid
    }

    static func getLoggedInUserName() -> String? {
        Auth.auth().currentUser?.displayName
    }

    static func addUserToDB(userID: String, email: String, username: String) {
        let db: DatabaseReference = Database.database().reference()

        db.child("users").child(userID).setValue([
            "email": email,
            "username": username
        ])
    }
}
