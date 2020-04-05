//
//  RoomCode.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct RoomCode: Hashable {
    let value: String
    let type: GameRoomType

    init(value: String, type: GameRoomType) {
        self.value = value
        self.type = type
    }

    static func == (lhs: RoomCode, rhs: RoomCode) -> Bool {
        lhs.value == rhs.value && lhs.type == rhs.type
    }
}
