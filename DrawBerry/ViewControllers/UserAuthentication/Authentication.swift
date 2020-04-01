//
//  Authentication.swift
//  DrawBerry
//
//  Created by Calvin Chen on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase

/// The `Authentication` class acts as a Facade which communicates with Firebase for user authentication matters.
class Authentication {
    private static let auth = Auth.auth()
    static weak var delegate: AuthenticationUpdateDelegate?

    /// Login an existing user with an email address and password.
    static func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { _, error in
            let loginStatus = (error == nil)

            delegate?.handleAuthenticationUpdate(status: loginStatus)
        }
    }

    /// Sign up a new user with an email address and password.
    static func signUp(username: String, email: String, password: String) {
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

            NetworkHelper.addUserToDB(userID: userID, email: email, username: username)
            delegate?.handleAuthenticationUpdate(status: true)
        }
    }

    /// Signs out the current user.
    static func signOut() {
        try? Auth.auth().signOut()
        delegate?.handleAuthenticationUpdate(status: true)
    }

}
