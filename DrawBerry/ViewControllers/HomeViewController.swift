//
//  HomeViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet private weak var background: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Authentication.delegate = self
        initializeElements()
    }

    func initializeElements() {
        background.image = Constants.mainMenuBackground
        background.alpha = Constants.backgroundAlpha
    }

    @IBAction private func handleLogOutButtonTapped(_ sender: UIButton) {
        Authentication.signOut()
    }

    func goToLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController

        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
}

extension HomeViewController: AuthenticationUpdateDelegate {

    func handleAuthenticationUpdate(status: Bool) {
        if status {
            goToLoginScreen()
        }
    }
}
