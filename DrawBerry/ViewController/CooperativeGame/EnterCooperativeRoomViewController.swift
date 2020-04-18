//
//  EnterCooperativeRoomViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class EnterCooperativeRoomViewController: UIViewController {
    var roomEnteringNetwork: RoomEnteringNetwork!

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var roomCodeField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = Constants.roomBackground
        background.alpha = Constants.backgroundAlpha
        errorLabel.alpha = 0
        roomEnteringNetwork = FirebaseRoomEnteringNetworkAdapter()
        roomCodeField.autocorrectionType = .no
        print("network connected")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomVC = segue.destination as? CooperativeGameRoomViewController,
            let roomCodeValue = roomCodeField.text {
            let roomCode = RoomCode(value: roomCodeValue, type: GameRoomType.CooperativeRoom)
            roomVC.room = CooperativeGameRoom(roomCode: roomCode)
            roomVC.room.delegate = roomVC
            roomVC.configureStartButton()
        }
    }

    /// Displays the error message.
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

    /// Checks if the room code is valid.
    private func isRoomCodeValid(_ roomCode: RoomCode) -> Bool {
        !roomCode.value.isEmpty
    }

    /// Joins the `CooperativeRoom` with the specified room code.
    private func joinRoom() {
        guard let roomCodeValue = roomCodeField.text else {
            showErrorMessage(Message.emptyTextField)
            return
        }
        let roomCode = RoomCode(value: roomCodeValue, type: .CooperativeRoom)

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

    /// Creates the `CooperativeRoom` with the specified room code.
    private func createRoom() {
        guard let roomCodeValue = StringHelper.trim(string: roomCodeField.text) else {
            showErrorMessage(Message.emptyTextField)
            return
        }
        let roomCode = RoomCode(value: roomCodeValue, type: .CooperativeRoom)
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
        performSegue(withIdentifier: "segueToCooperativeRoom", sender: self)
    }
}
