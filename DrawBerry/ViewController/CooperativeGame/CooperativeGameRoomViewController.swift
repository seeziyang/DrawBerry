//
//  CooperativeGameRoomViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CooperativeGameRoomViewController: UIViewController, GameRoomViewController {

    @IBOutlet internal weak var playersCollectionView: UICollectionView!
    @IBOutlet internal weak var startButton: UIBarButtonItem!
    @IBOutlet internal weak var roomCodeLabel: UINavigationItem!

    var room: GameRoom!
    internal var currentViewingPlayerID: String?

    internal var userProfileNetwork: UserProfileNetwork!

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        playersCollectionView.delegate = self
        playersCollectionView.dataSource = self

        roomCodeLabel.title = room.roomCode.value
        super.viewDidLoad()

        userProfileNetwork = FirebaseUserProfileNetworkAdapter()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let waitingVC = segue.destination as? WaitingViewController {
            waitingVC.cooperativeGame = CooperativeGame(from: room)
            waitingVC.cooperativeGame.delegate = waitingVC
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

    @IBAction private func startOnTap(_ sender: UIBarButtonItem) {
        startGame()
    }

    func segueToGameVC() {
        performSegue(withIdentifier: "segueToCooperativeGame", sender: self)
    }
}

extension CooperativeGameRoomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getNumOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        getCellForItem(at: indexPath)
    }
}

extension CooperativeGameRoomViewController: UICollectionViewDelegateFlowLayout {
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
extension CooperativeGameRoomViewController {

    /// Loads the user profile when single tap is detected on a specific cell.
    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        handleTap(sender: sender)
    }

    // TODO:
    internal func openUserProfile(at index: Int) {
        performSegue(withIdentifier: "segueCoopToPlayerProfile", sender: self)
    }
}
