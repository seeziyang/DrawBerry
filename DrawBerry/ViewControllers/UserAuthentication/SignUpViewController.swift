//
//  SignUpViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

// TODO: do smthg about username
class SignUpViewController: UIViewController {

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Authentication.delegate = self
        initializeElements()
    }

    func initializeElements() {
        background.image = Constants.signUpBackground
        background.alpha = Constants.backgroundAlpha
        errorLabel.alpha = 0
    }

    func validateTextFields() -> String? {
        guard let username = StringHelper.trim(string: usernameTextField.text),
              let email = StringHelper.trim(string: emailTextField.text),
              let password = StringHelper.trim(string: passwordTextField.text),
              let passwordConfirmation = StringHelper.trim(string: confirmPasswordTextField.text) else {
                return Message.emptyTextField
        }

        if username.isEmpty || email.isEmpty ||
        password.isEmpty || passwordConfirmation.isEmpty {
            return Message.whitespaceOnlyTextField
        }

        // Test regex
        if StringHelper.isInvalidEmail(email: email) {
            return Message.invalidEmail
        }

        if StringHelper.isInvalidPassword(password: password) {
            return Message.invalidPassword
        }

        if password != passwordConfirmation {
            return Message.passwordsDoNotMatch
        }

        return nil
    }

    func showErrorMessage(_ error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }

    @IBAction private func handleSignUpButtonTapped(_ sender: UIButton) {

        // Checks validity of user input
        if let errorMessage = validateTextFields() {
            showErrorMessage(errorMessage)
            return
        }

        guard let email = StringHelper.trim(string: emailTextField.text),
              let password = StringHelper.trim(string: passwordTextField.text) else {
            return
        }

        Authentication.signUp(email: email, password: password)
    }

    @IBAction private func goBackToLoginScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    private func goToHomeScreen() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}

extension SignUpViewController: AuthenticationUpdateDelegate {

    func handleAuthenticationUpdate(status: Bool) {
        if status {
            goToHomeScreen()
        } else {
            showErrorMessage(Message.signUpError)
        }
    }
}
