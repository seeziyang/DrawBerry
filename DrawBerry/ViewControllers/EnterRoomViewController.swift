//
//  EnterRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class EnterRoomViewController: UIViewController {

    var networkRoomHelper: NetworkRoomHelper!

    @IBOutlet private weak var roomCodeField: UITextField!

    @IBOutlet private weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.alpha = 0
        networkRoomHelper = NetworkRoomHelper()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomVC = segue.destination as? GameRoomViewController,
            let roomCode = roomCodeField.text {
            roomVC.room = GameRoom(roomCode: roomCode)
            roomVC.room.delegate = roomVC
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

    private func isRoomCodeValid(_ roomCode: String) -> Bool {
        !roomCode.isEmpty
    }

    private func joinRoom() {
        guard let roomCode = roomCodeField.text else {
            showErrorMessage(Message.emptyTextField)
            return
        }

        if !isRoomCodeValid(roomCode) {
            showErrorMessage(Message.whitespaceOnlyTextField)
            return
        }

        networkRoomHelper
            .checkRoomEnterable(roomCode: roomCode, completionHandler: { [weak self] roomStatus in
                switch roomStatus {
                case .enterable:
                    self?.networkRoomHelper.joinRoom(roomCode: roomCode)
                    self?.segueToRoomVC()
                case .doesNotExist:
                    self?.showErrorMessage(Message.roomDoesNotExist)
                case .full:
                    self?.showErrorMessage(Message.roomFull)
                }
            })
    }

    private func createRoom() {
        guard let roomCode = StringHelper.trim(string: roomCodeField.text) else {
            showErrorMessage(Message.emptyTextField)
            return
        }

        if !isRoomCodeValid(roomCode) {
            showErrorMessage(Message.whitespaceOnlyTextField)
            return
        }

        networkRoomHelper
            .checkRoomExists(roomCode: roomCode, completionHandler: { [weak self] roomExists in
                if !roomExists {
                    self?.networkRoomHelper.createRoom(roomCode: roomCode)
                    self?.segueToRoomVC()
                } else {
                    self?.showErrorMessage(Message.roomDoesNotExist)
                }
            })
    }

    private func segueToRoomVC() {
        performSegue(withIdentifier: "segueToRoom", sender: self)
    }
}
