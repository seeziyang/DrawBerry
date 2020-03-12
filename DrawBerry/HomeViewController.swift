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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func handleLogOutButtonTapped(_ sender: UIButton) {
        try? Auth.auth().signOut()
        goToLoginScreen()
    }

    func goToLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController

        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }


}
