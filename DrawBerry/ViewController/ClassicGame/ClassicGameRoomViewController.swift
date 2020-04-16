//
//  GameRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGameRoomViewController: UIViewController, GameRoomViewController {
    var room: GameRoom!
    internal var currentViewingPlayerID: String?

    @IBOutlet internal weak var startButton: UIBarButtonItem!
    @IBOutlet internal weak var playersCollectionView: UICollectionView!
    @IBOutlet internal weak var roomCodeLabel: UINavigationItem!
    @IBOutlet private weak var isRapidSwitch: UISwitch!

    internal var userProfileNetwork: UserProfileNetwork!

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        playersCollectionView.delegate = self
        playersCollectionView.dataSource = self

        roomCodeLabel.title = room.roomCode.value

        userProfileNetwork = FirebaseUserProfileNetworkAdapter()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let classicVC = segue.destination as? ClassicViewController {
            classicVC.classicGame = ClassicGame(from: room)
        }

        if let userProfileVC = segue.destination as? UserProfileViewController,
                let id = currentViewingPlayerID {
            userProfileVC.userProfileNetwork = FirebaseUserProfileNetworkAdapter()
            userProfileVC.setUserID(id: id)
        }
    }

    @IBAction private func backOnTap(_ sender: UIBarButtonItem) {
        leaveGameRoom()
    }

    @IBAction private func isRapidSwitchOnToggle(_ sender: UISwitch) {
        toggleIsRapid()
    }

    @IBAction private func startOnTap(_ sender: UIBarButtonItem) {
        startGame()
    }

    internal func configureButtons() {
        if let currentUser = room.user {
            if !currentUser.isRoomMaster {
                startButton.isEnabled = false
                startButton.tintColor = .clear

                isRapidSwitch.isEnabled = false
            } else {
                startButton.isEnabled = true
                startButton.tintColor = .systemBlue

                isRapidSwitch.isEnabled = true
            }
        }
    }

    func isRapidDidUpdate(isRapid: Bool) {
        isRapidSwitch.setOn(isRapid, animated: true)
    }

    private func toggleIsRapid() {
        room.toggleIsRapid()
    }

    internal func segueToGameVC() {
        performSegue(withIdentifier: "segueToClassicGame", sender: self)
    }
}

extension ClassicGameRoomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getNumOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        getCellForItem(at: indexPath)
    }
}

extension ClassicGameRoomViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        getSizeForItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        getInsetForSection(at: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        getMinimimumLineSpacingForSection(at: section)
    }
}

/// Handles gestures for `GameRoomViewController`
extension ClassicGameRoomViewController {

    /// Loads the user profile when single tap is detected on a specific cell.
    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        handleTap(sender: sender)
    }

    // TODO:
    internal func openUserProfile(at index: Int) {
        performSegue(withIdentifier: "segueClassicToPlayerProfile", sender: self)
    }
}
