//
//  EnterCooperativeRoomViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class EnterCooperativeRoomViewController: UIViewController, EnterRoomViewController {
    static let roomType: GameRoomType = .CooperativeRoom

    var roomEnteringNetwork: RoomEnteringNetwork!

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet internal weak var roomCodeField: UITextField!
    @IBOutlet internal weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = Constants.roomBackground
        background.alpha = Constants.backgroundAlpha
        errorLabel.alpha = 0
        roomEnteringNetwork = FirebaseRoomEnteringNetworkAdapter()
        print("network connected")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomVC = segue.destination as? CooperativeGameRoomViewController,
            let roomCodeValue = roomCodeField.text {
            let roomCode = RoomCode(value: roomCodeValue, type: GameRoomType.CooperativeRoom)
            roomVC.room = GameRoom(roomCode: roomCode)
            roomVC.room.delegate = roomVC
            roomVC.configureStartButton()
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
        performSegue(withIdentifier: "segueToCooperativeRoom", sender: self)
    }
}
