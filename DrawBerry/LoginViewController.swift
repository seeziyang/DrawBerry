//
//  LoginViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeElements()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "loginToHome", sender: self)
            //goToHomeScreen()
        }
    }

    func initializeElements() {
        errorLabel.alpha = 0
        usernameTextField.text = "sample username"
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    func showErrorMessage(_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }

    func validateTextFields() -> String? {
        guard let email = Helper.trim(string: emailTextField.text),
            let password = Helper.trim(string: passwordTextField.text) else {
                return "Empty field"
        }

        guard email != "", password != "" else {
            return "Whitespace"
        }

        return nil
    }
    
    @IBAction func handleLoginButtonTapped(_ sender: UIButton) {
        // Check for empty fields
        if let errorMessage = validateTextFields() {
            showErrorMessage(errorMessage)
            return
        }

        guard let email = Helper.trim(string: emailTextField.text!),
              let password = Helper.trim(string: passwordTextField.text!) else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in

            if error != nil {
                self.showErrorMessage("Account not registered")
            } else {
                self.performSegue(withIdentifier: "loginToHome", sender: self)
                // self.goToHomeScreen()
            }
        }
    }
//
//    func goToHomeScreen() {
//        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
//
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
//    }

}
