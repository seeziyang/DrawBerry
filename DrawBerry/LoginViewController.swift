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
            goToHomeScreen()
        }
    }

    func initializeElements() {
        errorLabel.alpha = 0
        emailTextField.text = "test@test.com"
        passwordTextField.text = "123456"
    }

    /// Shows an error message on the page
    func showErrorMessage(_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }

    /// Checks if user inputs are valid
    /// Returns an error message
    /// Returns nil if no errors are found
    func validateTextFields() -> String? {
        guard let email = Helper.trim(string: emailTextField.text),
            let password = Helper.trim(string: passwordTextField.text) else {
                return Message.emptyTextField
        }

        if email == "" || password == "" {
            return Message.whitespaceOnlyTextField
        }

        return nil
    }
    
    @IBAction func handleLoginButtonTapped(_ sender: UIButton) {
        // Checks input text-fields
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
                self.showErrorMessage(Message.signInError)
            } else {
                self.goToHomeScreen()
            }
        }
    }

    func goToHomeScreen() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController

        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
