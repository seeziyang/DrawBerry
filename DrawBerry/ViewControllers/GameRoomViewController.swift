//
//  GameRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class GameRoomViewController: UIViewController, GameRoomDelegate {
    var room: GameRoom!

    @IBOutlet private weak var playersTableView: UITableView!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO
//        if let roomVC = segue.destination as? GameRoomViewController,
//            let roomCode = roomCodeField.text {
//            roomVC.room = GameRoom(roomCode: roomCode)
//            roomVC.room.delegate = roomVC
//        }
    }

    @IBAction private func backOnTap(_ sender: UIBarButtonItem) {
        leaveGameRoom()
    }

    @IBAction private func startOnTap(_ sender: UIBarButtonItem) {
        startGame()
    }

    func playersDidUpdate() {
        playersTableView.reloadData()
    }

    private func leaveGameRoom() {
        // TODO: Exit game room

        dismiss(animated: true, completion: nil)
    }

    private func startGame() {
        // TODO: Check min players

        segueToGameVC()
    }

    private func segueToGameVC() {
        performSegue(withIdentifier: "segueToClassicGame", sender: self)
    }
}

extension GameRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        room.players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        cell.textLabel?.text = room.players[indexPath.row].name
        return cell
    }

}
