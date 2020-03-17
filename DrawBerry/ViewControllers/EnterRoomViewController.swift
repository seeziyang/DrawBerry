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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        networkRoomHelper = NetworkRoomHelper()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomVC = segue.destination as? GameRoomViewController,
            let roomCode = roomCodeField.text {
            roomVC.room = GameRoom(roomCode: roomCode)
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

    private func isRoomCodeValid(_ roomCode: String) -> Bool {
        // TODO
        // check valid string
        return !roomCode.isEmpty
    }

    private func joinRoom() {
        guard let roomCode = roomCodeField.text else {
            return
        }

        if !isRoomCodeValid(roomCode) {
            return // TODO: show error message
        }

        networkRoomHelper
            .checkRoomExists(roomCode: roomCode, completionHandler: { [weak self] roomExists in
                if roomExists {
                    self?.networkRoomHelper.joinRoom(roomCode: roomCode)
                    self?.segueToRoomVC()
                } else {
                    // TODO: show error message
                }
            })
    }

    private func createRoom() {
        guard let roomCode = roomCodeField.text else {
            return
        }

        if !isRoomCodeValid(roomCode) {
            return // TODO: show error message
        }

        networkRoomHelper
            .checkRoomExists(roomCode: roomCode, completionHandler: { [weak self] roomExists in
                if !roomExists {
                    self?.networkRoomHelper.createRoom(roomCode: roomCode)
                    self?.segueToRoomVC()
                } else {
                    // TODO: show error message
                }
            })
    }

    private func segueToRoomVC() {
        performSegue(withIdentifier: "segueToRoom", sender: self)
    }
}
