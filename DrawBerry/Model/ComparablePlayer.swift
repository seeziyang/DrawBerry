//
//  ComparablePlayer.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 31/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class ComparablePlayer: Player {
    let name: String
    let uid: String

    init(name: String, uid: String) {
        self.name = name
        self.uid = uid
    }
}

extension ComparablePlayer: Comparable {
    static func < (lhs: ComparablePlayer, rhs: ComparablePlayer) -> Bool {
        lhs.uid < rhs.uid
    }

    static func == (lhs: ComparablePlayer, rhs: ComparablePlayer) -> Bool {
        lhs.uid == rhs.uid
    }
}
