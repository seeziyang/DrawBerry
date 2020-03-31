//
//  RoomPlayer.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Foundation

class RoomPlayer: ComparablePlayer {
    var isRoomMaster: Bool

    init(name: String, uid: String, isRoomMaster: Bool) {
        self.isRoomMaster = isRoomMaster
        super.init(name: name, uid: uid)
    }
}
