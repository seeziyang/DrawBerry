//
//  EnterRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class EnterClassicRoomViewController: UIViewController {
    var roomEnteringNetwork: RoomEnteringNetwork!
    var usersNonRapidGameRoomCodes: [RoomCode]!
    var usersNonRapidGameStatuses: [RoomCode: (isMyTurn: Bool, game: ClassicGame)]!

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var roomCodeField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
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
                completionHandler: { [weak self] activeRoomTurn, classicGame in
                    self?.usersNonRapidGameStatuses[roomCode] = (activeRoomTurn, classicGame)

                    self?.activeNonRapidGamesTable.reloadData()
                }
            )
        }
    }

    func showErrorMessage(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
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

    private func isRoomCodeValid(_ roomCode: RoomCode) -> Bool {
        !roomCode.value.isEmpty
    }

    private func joinRoom() {
        guard let roomCodeValue = roomCodeField.text else {
            showErrorMessage(Message.emptyTextField)
            return
        }
        let roomCode = RoomCode(value: roomCodeValue, type: GameRoomType.ClassicRoom)

        if !isRoomCodeValid(roomCode) {
            showErrorMessage(Message.whitespaceOnlyTextField)
            return
        }

        roomEnteringNetwork
            .checkRoomEnterable(roomCode: roomCode, completionHandler: { [weak self] roomStatus in
                switch roomStatus {
                case .enterable:
                    self?.roomEnteringNetwork.joinRoom(roomCode: roomCode)
                    self?.segueToRoomVC()
                case .doesNotExist:
                    self?.showErrorMessage(Message.roomDoesNotExist)
                case .full:
                    self?.showErrorMessage(Message.roomFull)
                case .started:
                    self?.showErrorMessage(Message.roomStarted)
                }
            })
    }

    private func createRoom() {
        guard let roomCodeValue = StringHelper.trim(string: roomCodeField.text) else {
            showErrorMessage(Message.emptyTextField)
            return
        }
        let roomCode = RoomCode(value: roomCodeValue, type: GameRoomType.ClassicRoom)
        if !isRoomCodeValid(roomCode) {
            showErrorMessage(Message.whitespaceOnlyTextField)
            return
        }

        roomEnteringNetwork
            .checkRoomExists(roomCode: roomCode, completionHandler: { [weak self] roomExists in
                if !roomExists {
                    self?.roomEnteringNetwork.createRoom(roomCode: roomCode)
                    self?.segueToRoomVC()
                } else {
                    self?.showErrorMessage(Message.roomCodeTaken)
                }
            })
    }

    private func segueToRoomVC() {
        performSegue(withIdentifier: "segueToClassicRoom", sender: self)
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
        cell.addGestureRecognizer(tapGestureRecognizer)

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
}
