//
//  TeamBattlePlayer.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattlePlayer: ComparablePlayer {
    let name: String
    let uid: String
    var isRoomMaster: Bool
    var points: Int

    init(name: String, uid: String, isRoomMaster: Bool, points: Int = 0) {
        self.name = name
        self.uid = uid
        self.isRoomMaster = isRoomMaster
        self.points = points
    }

    /// Constructs a `TeamBattlePlayer` from a `RoomPlayer`.
    convenience init(from roomPlayer: RoomPlayer) {
        self.init(name: roomPlayer.name, uid: roomPlayer.uid, isRoomMaster: roomPlayer.isRoomMaster)
    }

}
