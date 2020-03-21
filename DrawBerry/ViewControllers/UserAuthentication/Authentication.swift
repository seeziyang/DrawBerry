//
//  Authentication.swift
//  DrawBerry
//
//  Created by Calvin Chen on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

class Authentication {
    private static let auth = Auth.auth()
    static weak var delegate: AuthenticationUpdateDelegate?

    static func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if error == nil {
                delegate?.handleAuthenticationUpdate(status: true)
            } else {
                delegate?.handleAuthenticationUpdate(status: false)
            }
        }
    }

    static func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in

            if error != nil {
                // TODO: show more descriptive error based on error code
                delegate?.handleAuthenticationUpdate(status: false)
                return
            }

            guard let userID = result?.user.uid, let email = result?.user.email else {
                delegate?.handleAuthenticationUpdate(status: false)
                return
            }

            NetworkHelper.addUserToDB(userID: userID, email: email)
            delegate?.handleAuthenticationUpdate(status: true)
        }
    }

    static func signOut() {
        try? Auth.auth().signOut()
        delegate?.handleAuthenticationUpdate(status: true)
    }

}
