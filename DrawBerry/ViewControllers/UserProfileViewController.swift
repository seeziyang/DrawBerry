//
//  UserProfileViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 30/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet private weak var imageCollectionView: UICollectionView!

    private var userID: String?
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 5
    private let maxImagesInGallery = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func reloadData() {
        imageCollectionView.reloadData()
    }

    func setUserID(id: String) {
        userID = id
        UserProfileNetworkAdapter.getListOfImages(delegate: self, playerUID: id)
    }

    @IBAction private func backToRoom(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension UserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxImagesInGallery
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getReusableCell(for: indexPath)

        UserProfileNetworkAdapter.downloadImage(delegate: cell, index: indexPath.row)

        return cell
    }

    private func getReusableCell(for indexPath: IndexPath) -> ImageCollectionViewCell {
        guard let cell = imageCollectionView.dequeueReusableCell(
            withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell else {
                fatalError("Unable to get reusable cell.")
        }
        cell.backgroundColor = .yellow
        return cell
    }
}

// Code for layout adapted from https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started
extension UserProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = imageCollectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}