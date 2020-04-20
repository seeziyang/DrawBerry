//
//  FirebaseNetworkAdapter.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

protocol FirebaseNetworkAdapter: NetworkInterface {
    var db: DatabaseReference { get }
}

extension FirebaseNetworkAdapter {
    func getLoggedInUserID() -> String? {
        Auth.auth().currentUser?.uid
    }

    func getLoggedInUserName() -> String? {
        Auth.auth().currentUser?.displayName
    }
}
