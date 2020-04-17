//
//  EnterRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class EnterClassicRoomViewController: UIViewController, EnterRoomViewController {
    static let roomType: GameRoomType = .ClassicRoom

    internal var roomEnteringNetwork: RoomEnteringNetwork!
    var usersNonRapidGameRoomCodes: [RoomCode]!
    var usersNonRapidGameStatuses: [RoomCode: (isMyTurn: Bool, game: NonRapidClassicGame)]!

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet internal weak var roomCodeField: UITextField!
    @IBOutlet internal weak var errorLabel: UILabel!
    @IBOutlet private weak var activeNonRapidGamesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = Constants.roomBackground
        background.alpha = Constants.backgroundAlpha
        errorLabel.alpha = 0

        roomEnteringNetwork = FirebaseRoomEnteringNetworkAdapter()
        loadActiveNonRapidGamesTable()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomVC = segue.destination as? ClassicGameRoomViewController,
            let roomCodeValue = roomCodeField.text {
                let roomCode = RoomCode(value: roomCodeValue, type: GameRoomType.ClassicRoom)
                roomVC.room = GameRoom(roomCode: roomCode)
                roomVC.room.delegate = roomVC
        } else if let votingVC = segue.destination as? VotingViewController,
            let roomCode = sender as? RoomCode,
            let classicGame = usersNonRapidGameStatuses[roomCode]?.game {
                votingVC.classicGame = classicGame
                votingVC.classicGame.delegate = votingVC
                votingVC.classicGame.observePlayersDrawing()
        } else if let resultsVC = segue.destination as? ClassicGameEndViewController,
            let roomCode = sender as? RoomCode,
            let classicGame = usersNonRapidGameStatuses[roomCode]?.game {
                resultsVC.classicGame = classicGame
        }
    }

    private func loadActiveNonRapidGamesTable() {
        // load user's active Non-Rapid Classic Games
        roomEnteringNetwork.getUsersNonRapidGameRoomCodes(completionHandler: { [weak self] roomCodes in
            self?.usersNonRapidGameRoomCodes = roomCodes
            self?.usersNonRapidGameStatuses = [:]

            self?.activeNonRapidGamesTable.reloadData()

            self?.loadActiveNonRapidGameStatuses()
        })
    }

    private func loadActiveNonRapidGameStatuses() {
        usersNonRapidGameRoomCodes.forEach { roomCode in
            roomEnteringNetwork.observeNonRapidGamesTurn(
                roomCode: roomCode,
                completionHandler: { [weak self] activeRoomTurn, nonRapidClassicGame in
                    self?.usersNonRapidGameStatuses[roomCode] = (activeRoomTurn, nonRapidClassicGame)

                    self?.activeNonRapidGamesTable.reloadData()
                }
            )
        }
    }

    @IBAction private func backOnTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func joinOnTap(_ sender: UIButton) {
        joinRoom()
    }

    @IBAction private func createOnTap(_ sender: UIButton) {
        createRoom()
    }

    func segueToRoomVC() {
        performSegue(withIdentifier: "segueToClassicRoom", sender: self)
    }

    @IBAction private func unwindToEnterClassicGameRoomVC(segue: UIStoryboardSegue) {
    }
}

extension EnterClassicRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersNonRapidGameRoomCodes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activeNonRapidGamesTable.dequeueReusableCell(withIdentifier: "roomCodeCell",
                                                                for: indexPath)
        let roomCode = usersNonRapidGameRoomCodes[indexPath.row]
        var text = roomCode.value

        if let status = usersNonRapidGameStatuses[roomCode] {
            text += ", Round: \(status.game.currentRound)"
            text += ", \(status.isMyTurn ? "Your turn!" : "Waiting for other players")"
        }

        cell.textLabel?.text = text

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleCellTap(_:)))
        let longPressGestureRecognizer =
            UILongPressGestureRecognizer(target: self, action: #selector(handleCellLongPress(_:)))
        cell.addGestureRecognizer(tapGestureRecognizer)
        cell.addGestureRecognizer(longPressGestureRecognizer)

        return cell
    }

    @objc private func handleCellTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UITableViewCell else {
            return
        }

        guard let index = activeNonRapidGamesTable.indexPath(for: cell)?.row else {
            return
        }

        let roomCode = usersNonRapidGameRoomCodes[index]
        guard let status = usersNonRapidGameStatuses[roomCode] else {
            return
        }

        if status.isMyTurn {
            performSegue(withIdentifier: "segueToVotingFromEnterRoom", sender: roomCode)
        } else {
            // TODO: Show some alert?
        }
    }

    @objc private func handleCellLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let cell = sender.view as? UITableViewCell else {
                return
            }

            guard let index = activeNonRapidGamesTable.indexPath(for: cell)?.row else {
                return
            }

            let roomCode = usersNonRapidGameRoomCodes[index]
            performSegue(withIdentifier: "segueToResults", sender: roomCode)
        }
    }
}
