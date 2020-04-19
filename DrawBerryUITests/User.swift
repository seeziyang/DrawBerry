//
//  User.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 19/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct User {
    let email: String
    let password: String
    let name: String
    let uid: String

    init(email: String, password: String, name: String, uid: String) {
        self.email = email
        self.password = password
        self.name = name
        self.uid = uid
    }
}
