//
//  GameRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicGameRoomViewController: UIViewController, GameRoomDelegate {
    var room: GameRoom!

    @IBOutlet private weak var playersTableView: UITableView!
    @IBOutlet private weak var startButton: UIBarButtonItem!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let classicVC = segue.destination as? ClassicViewController {
            classicVC.classicGame = ClassicGame(from: room)
        }
    }

    @IBAction private func backOnTap(_ sender: UIBarButtonItem) {
        leaveGameRoom()
    }

    @IBAction private func startOnTap(_ sender: UIBarButtonItem) {
        startGame()
    }

    func configureStartButton() {
        if let currentUser = room.user {
            if !currentUser.isRoomMaster {
                startButton.isEnabled = false
                startButton.tintColor = UIColor.clear
            }
        }
    }

    func playersDidUpdate() {
        playersTableView.reloadData()
        configureStartButton()
    }

    func gameHasStarted() {
        segueToGameVC()
    }

    private func leaveGameRoom() {
        room.leaveRoom()

        dismiss(animated: true, completion: nil)
    }

    private func startGame() {
        // TODO: make only roomMaster can startGame?

        if !room.canStart {
            // TODO: show some UIPrompt indicating minPlayer amount not reached
            return
        }

        room.startGame()
        segueToGameVC()
    }

    private func segueToGameVC() {
        performSegue(withIdentifier: "segueToClassicGame", sender: self)
    }
}

extension ClassicGameRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        room.players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "classicPlayerCell", for: indexPath)
        cell.textLabel?.text = room.players[indexPath.row].name
        return cell
    }

}
