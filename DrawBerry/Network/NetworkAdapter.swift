//
//  NetworkAdapter.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 18/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol NetworkAdapter {

}

extension NetworkAdapter {
    func getLoggedInUserID() -> String? {
        NetworkHelper.getLoggedInUserID()
    }

    func getLoggedInUserName() -> String? {
        NetworkHelper.getLoggedInUserName()
    }

    func addUserToDB(userID: String, email: String, username: String) {
        NetworkHelper.addUserToDB(userID: userID, email: email, username: username)
    }
}
