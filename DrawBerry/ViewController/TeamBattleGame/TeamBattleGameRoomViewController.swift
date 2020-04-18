//
//  TeamBattleGameRoomViewController.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleGameRoomViewController: UIViewController, GameRoomViewController {

    @IBOutlet internal weak var playersCollectionView: UICollectionView!
    @IBOutlet internal weak var startButton: UIBarButtonItem!
    @IBOutlet internal weak var roomCodeLabel: UINavigationItem!

    var room: TeamBattleGameRoom!
    internal var currentViewingPlayerID: String?

    internal var userProfileNetwork: UserProfileNetwork!

    /// Hides the status bar at the top
    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        playersCollectionView.delegate = self
        playersCollectionView.dataSource = self
        super.viewDidLoad()

        roomCodeLabel.title = room.roomCode.value
        userProfileNetwork = FirebaseUserProfileNetworkAdapter()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let teamBattleDrawVC = segue.destination as? TeamBattleDrawingViewController {
            teamBattleDrawVC.game = TeamBattleGame(from: room)
        }

        if let teamBattleGuessVC = segue.destination as? TeamBattleGuessingViewController {
            teamBattleGuessVC.game = TeamBattleGame(from: room)

            teamBattleGuessVC.game.delegate = teamBattleGuessVC
            teamBattleGuessVC.game.observeTeamDrawing()
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

    private func getPlayerIndex(user: RoomPlayer, players: [RoomPlayer]) -> Int? {
        for i in 0..<players.count where players[i] == user {
            return i
        }

        return nil
    }

    func segueToGameVC() {
        guard let user = room.user,
            let userIndex = getPlayerIndex(user: user, players: room.players) else {
            return
        }
        userIndex.isMultiple(of: 2) ? segueToDrawingVC(): segueToGuessingVC()
    }

    private func segueToDrawingVC() {
        performSegue(withIdentifier: "segueToTeamBattleDrawing", sender: self)
    }

    private func segueToGuessingVC() {
        performSegue(withIdentifier: "segueToTeamBattleGuessing", sender: self)
    }
}

extension TeamBattleGameRoomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getNumOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        getCellForItem(at: indexPath)
    }
}

extension TeamBattleGameRoomViewController: UICollectionViewDelegateFlowLayout {
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

/// Handles gestures for `TeamBattleGameRoomViewController`
extension TeamBattleGameRoomViewController {

    /// Loads the user profile when single tap is detected on a specific cell.
    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        handleTap(sender: sender)
    }

    // TODO:
    internal func openUserProfile(at index: Int) {
        // performSegue(withIdentifier: "segueTeamBattleToPlayerProfile", sender: self)
    }
}
