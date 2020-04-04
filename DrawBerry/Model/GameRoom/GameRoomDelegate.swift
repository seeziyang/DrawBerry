//
//  GameRoomDelegate.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol GameRoomDelegate: AnyObject {
    func playersDidUpdate()

    func gameHasStarted()

    func isRapidDidUpdate(isRapid: Bool)
}

extension GameRoomDelegate {
    func isRapidDidUpdate(isRapid: Bool) {
    }
}
