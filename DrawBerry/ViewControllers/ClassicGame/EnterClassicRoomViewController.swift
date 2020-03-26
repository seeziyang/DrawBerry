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
    var roomNetworkAdapter: RoomNetworkAdapter!

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var roomCodeField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = Constants.roomBackground
        background.alpha = Constants.backgroundAlpha
        errorLabel.alpha = 0
        roomNetworkAdapter = RoomNetworkAdapter()
        print("network connected")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomVC = segue.destination as? ClassicGameRoomViewController,
            let roomCodeValue = roomCodeField.text {
            let roomCode = RoomCode(value: roomCodeValue, type: GameRoomType.ClassicRoom)
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

        roomNetworkAdapter
            .checkRoomEnterable(roomCode: roomCode, completionHandler: { [weak self] roomStatus in
                switch roomStatus {
                case .enterable:
                    self?.roomNetworkAdapter.joinRoom(roomCode: roomCode)
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

        roomNetworkAdapter
            .checkRoomExists(roomCode: roomCode, completionHandler: { [weak self] roomExists in
                if !roomExists {
                    self?.roomNetworkAdapter.createRoom(roomCode: roomCode)
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
