//
//  AuthenticationUpdateDelegate.swift
//  DrawBerry
//
//  Created by Calvin Chen on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

/// The `AuthenticationUpdateDelegate` handles
/// replies from third-party libraries with regards to user authentication
/// such as success or failure in login/sign-ups and logouts
protocol AuthenticationUpdateDelegate: AnyObject {

    func handleAuthenticationUpdate(status: Bool)
}
