//
//  NetworkClient.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 18/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol NetworkInterface {
    func getLoggedInUserID() -> String?

    func getLoggedInUserName() -> String?

//    func addUserToDB(userID: String, email: String, username: String)
}

//extension NetworkInterface {
//    func getLoggedInUserID() -> String? {
//        NetworkHelper.getLoggedInUserID()
//    }
//
//    func getLoggedInUserName() -> String? {
//        NetworkHelper.getLoggedInUserName()
//    }
//
//    func addUserToDB(userID: String, email: String, username: String) {
//        NetworkHelper.addUserToDB(userID: userID, email: email, username: username)
//    }
//}
