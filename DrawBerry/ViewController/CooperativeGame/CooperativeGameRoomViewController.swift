//
//  CooperativeGameRoomViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CooperativeGameRoomViewController: UIViewController, GameRoomDelegate {

    @IBOutlet private weak var playersCollectionView: UICollectionView!
    @IBOutlet private weak var startButton: UIBarButtonItem!

    var room: GameRoom!
    private var currentViewingPlayerID: String?

    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 160.0, bottom: 50.0, right: 160.0)
    private let itemsPerRow: CGFloat = 2

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        true
    }

    /// Enable or Disable the start button, depending on whether
    /// the user is the room master or not.
    func configureStartButton() {
        if let currentUser = room.user {
            if !currentUser.isRoomMaster {
                startButton.isEnabled = false
                startButton.tintColor = UIColor.clear
            }
        }
    }

    override func viewDidLoad() {
        playersCollectionView.delegate = self
        playersCollectionView.dataSource = self
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let waitingVC = segue.destination as? WaitingViewController {
            waitingVC.cooperativeGame = CooperativeGame(from: room)
            waitingVC.cooperativeGame.delegate = waitingVC
        }

        if segue.destination is UserProfileViewController {
            let target = segue.destination as? UserProfileViewController
            guard let id = currentViewingPlayerID else {
                return
            }

            target?.setUserID(id: id)
        }
    }

    @IBAction private func backOnTap(_ sender: UIBarButtonItem) {
        leaveGameRoom()
    }

    @IBAction private func startOnTap(_ sender: UIBarButtonItem) {
        startGame()
    }

    /// Reloads the collection view when a player joins or leave the room.
    func playersDidUpdate() {
        playersCollectionView.reloadData()
        configureStartButton()
    }

    /// Navigates to the game view controller.
    func gameHasStarted() {
        segueToGameVC()
    }

    /// Removes the user from the current game room.
    private func leaveGameRoom() {
        room.leaveRoom()

        dismiss(animated: true, completion: nil)
    }

    /// Starts the game if the number of players in the room is a valid number.
    private func startGame() {
        if !room.canStart {
            return
        }

        room.startGame()
        segueToGameVC()
    }

    private func segueToGameVC() {
        performSegue(withIdentifier: "segueToCooperativeGame", sender: self)
    }
}

extension CooperativeGameRoomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        GameRoom.maxPlayers
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getReusableCell(for: indexPath)

        guard indexPath.row < room.players.count else {
            return cell
        }

        let player = room.players[indexPath.row]

        // Truncate uid for testing
        let username = String(player.name.prefix(10))

        UserProfileNetworkAdapter.downloadProfileImage(delegate: cell, playerUID: player.uid)

        cell.setUsername(username)

        return cell
    }

    private func getReusableCell(for indexPath: IndexPath) -> PlayerCollectionViewCell {
        guard let cell = playersCollectionView.dequeueReusableCell(
            withReuseIdentifier: "playerCell", for: indexPath) as? PlayerCollectionViewCell else {
                fatalError("Unable to get reusable cell.")
        }
        cell.setCircularShape()
        cell.setDefaultImage()
        cell.setUsername("Empty Slot")
        return cell
    }
}

// Code for layout adapted from https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started
extension CooperativeGameRoomViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = playersCollectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
}

/// Handles gestures for `GameRoomViewController`
extension CooperativeGameRoomViewController {

    /// Loads the user profile when single tap is detected on a specific cell.
    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: playersCollectionView)
        guard let indexPath = playersCollectionView.indexPathForItem(at: location) else {
            return
        }

        // Disable gestures on empty slots
        guard indexPath.row < room.players.count else {
            return
        }
        currentViewingPlayerID = room.players[indexPath.row].uid
        openUserProfile(at: indexPath.row)
    }

    // TODO:
    private func openUserProfile(at index: Int) {
        performSegue(withIdentifier: "segueCoopToPlayerProfile", sender: self)
    }
}
