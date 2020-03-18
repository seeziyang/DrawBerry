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

    func playersDidUpdate() {
        playersTableView.reloadData()
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
