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
    @IBOutlet private weak var profileImageView: UIImageView!

    private var imagePicker: UIImagePickerController!

    private var userProfileNetwork: UserProfileNetworkAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeElements()
        setupImagePicker()

        userProfileNetwork = UserProfileNetworkAdapter()
        userProfileNetwork.downloadProfileImage(delegate: self, playerUID: NetworkHelper.getLoggedInUserID())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Authentication.delegate = self
    }

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        true
    }

    func initializeElements() {
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.height
        profileImageView.clipsToBounds = true

        background.image = Constants.mainMenuBackground
        background.alpha = Constants.backgroundAlpha
    }

    func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }

    @IBAction private func handleProfilePictureTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction private func handleLogOutButtonTapped(_ sender: UIButton) {
        Authentication.signOut()
    }

    func goToLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController

        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction private func unwindToHomeVC(segue: UIStoryboardSegue) {
    }
}

extension HomeViewController: UserProfileNetworkDelegate {
    func loadImage(image: UIImage?) {
        if let image = image {
            profileImageView.image = image
        } else {
            profileImageView.image = Constants.defaultProfilePicture
        }
    }

}

extension HomeViewController: AuthenticationUpdateDelegate {

    func handleAuthenticationUpdate(status: Bool) {
        if status {
            goToLoginScreen()
        }
    }
}

/// Extension for image picker
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = image
            userProfileNetwork.uploadProfileImage(image)
            userProfileNetwork.uploadImageToFavourites(image)
        }

        picker.dismiss(animated: true, completion: nil)

    }

}
