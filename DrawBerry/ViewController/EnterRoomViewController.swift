//
//  EnterRoomViewController.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol EnterRoomViewController: UIViewController {
    static var roomType: GameRoomType { get }

    var roomEnteringNetwork: RoomEnteringNetwork! { get }

    var roomCodeField: UITextField! { get set }
    var errorLabel: UILabel! { get set }

    func segueToRoomVC()

    func showErrorMessage(_ message: String)

    func isRoomCodeValid(_ roomCode: RoomCode) -> Bool

    func joinRoom()

    func createRoom()
}

extension EnterRoomViewController {
    func showErrorMessage(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func isRoomCodeValid(_ roomCode: RoomCode) -> Bool {
        !roomCode.value.isEmpty
    }

    func joinRoom() {
        guard let roomCodeValue = roomCodeField.text else {
            showErrorMessage(Message.emptyTextField)
            return
        }
        let roomCode = RoomCode(value: roomCodeValue, type: Self.roomType)

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

    func createRoom() {
        guard let roomCodeValue = StringHelper.trim(string: roomCodeField.text) else {
            showErrorMessage(Message.emptyTextField)
            return
        }
        let roomCode = RoomCode(value: roomCodeValue, type: Self.roomType)
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
}
