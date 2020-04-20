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
}
