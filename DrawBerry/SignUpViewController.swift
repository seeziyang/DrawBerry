//
//  SignUpViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeElements()
    }

    func initializeElements() {
        errorLabel.alpha = 0
    }

    func validateTextFields() -> String? {
        guard let username = Helper.trim(string: usernameTextField.text),
            let email = Helper.trim(string: emailTextField.text),
            let password = Helper.trim(string: passwordTextField.text) else {
                return "Empty field"
        }

        guard username != "", email != "", password != "" else {
            return "Whitespace"
        }
        // TODO: Test Regex
        return nil
    }

    func showErrorMessage(_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    

    @IBAction func handleSignUpButtonTapped(_ sender: UIButton) {

        // Check for empty fields
        if let errorMessage = validateTextFields() {
            showErrorMessage(errorMessage)
            return
        }

        guard let email = Helper.trim(string: emailTextField.text!),
              let password = Helper.trim(string: passwordTextField.text!) else {
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in

            if error != nil {
                print(error?.localizedDescription ?? "")
                self.showErrorMessage("Unable to register user")
            } else {
                // TODO: Store relevant data in firestore
                self.performSegue(withIdentifier: "loginToHome", sender: self)
                //self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func goBackToLoginScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    func goToHomeScreen() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController

        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
