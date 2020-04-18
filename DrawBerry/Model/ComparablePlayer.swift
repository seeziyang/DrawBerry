//
//  ComparablePlayer.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 31/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol ComparablePlayer: Player, Comparable {
    var uid: String { get }

    var isRoomMaster: Bool { get set }
}

extension ComparablePlayer {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.uid < rhs.uid
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uid == rhs.uid
    }
}
