//
//  GameRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol GameRoomViewController: UIViewController, GameRoomDelegate,
        UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    associatedtype Room: GameRoom

    var room: Room! { get set }

    var playersCollectionView: UICollectionView! { get set }
    var startButton: UIBarButtonItem! { get set }
    var roomCodeLabel: UINavigationItem! { get set }

    var currentViewingPlayerID: String? { get set }
    var userProfileNetwork: UserProfileNetwork! { get set }

    var sectionInsets: UIEdgeInsets { get }
    var itemsPerRow: CGFloat { get }

    func configureButtons()

    func leaveGameRoom()

    func startGame()

    func segueToGameVC()

    func openUserProfile(at index: Int)
}

extension GameRoomViewController {
    var sectionInsets: UIEdgeInsets {
        UIEdgeInsets(top: 50.0, left: 160.0, bottom: 50.0, right: 160.0)
    }

    var itemsPerRow: CGFloat {
        2
    }

    func configureButtons() {
        if let currentUser = room.user {
            if !currentUser.isRoomMaster {
                startButton.isEnabled = false
                startButton.tintColor = UIColor.clear
            } else {
                startButton.isEnabled = true
                startButton.tintColor = .systemBlue
            }
        }
    }

    func playersDidUpdate() {
        if room.didPlayersCountChange ?? true {
            playersCollectionView.reloadData()
        }
        configureButtons()
    }

    func gameHasStarted() {
        segueToGameVC()
    }

    func leaveGameRoom() {
        room.leaveRoom()

        dismiss(animated: true, completion: nil)
    }

    func startGame() {
        if !room.canStart {
            return
        }

        room.startGame()
        segueToGameVC()
    }
}

// UICollectionViewDataSource non-objc implementations
extension GameRoomViewController {
    func getNumOfItemsInSection() -> Int {
        GameRoom.maxPlayers
    }

    func getCellForItem(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = getReusableCell(for: indexPath)

        guard indexPath.row < room.players.count else {
            return cell
        }

        let player = room.players[indexPath.row]
        let username = player.name

        userProfileNetwork.downloadProfileImage(delegate: cell, playerUID: player.uid)

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
// UICollectionViewDelegateFlowLayout non-objc implementations
extension GameRoomViewController {
    func getSizeForItem(at indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = playersCollectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func getInsetForSection(at section: Int) -> UIEdgeInsets {
        sectionInsets
    }

    func getMinimimumLineSpacingForSection(at section: Int) -> CGFloat {
        sectionInsets.left
    }
}

// Handle Tap Gesture for Profile
extension GameRoomViewController {
    func handleTap(sender: UITapGestureRecognizer) {
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
}
