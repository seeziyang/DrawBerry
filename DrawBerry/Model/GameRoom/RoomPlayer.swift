//
//  RoomPlayer.swift
//  DrawBerry
//
//  Created by See Zi Yang on 16/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Foundation

class RoomPlayer: ComparablePlayer {
    let name: String
    let uid: String
    var isRoomMaster: Bool

    init(name: String, uid: String, isRoomMaster: Bool) {
        self.name = name
        self.uid = uid
        self.isRoomMaster = isRoomMaster
    }

    convenience init(name: String, uid: String) {
        self.init(name: name, uid: uid, isRoomMaster: false)
    }
}
