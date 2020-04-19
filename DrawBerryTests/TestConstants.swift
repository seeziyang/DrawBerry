//
//  TestConstants.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 18/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

struct TestConstants {
    static let admin1 = RoomPlayer(name: "admin1", uid: "I1jcaAauaUQWp7uHuyMHlyDZRlP2", isRoomMaster: true)
    static let admin2 = RoomPlayer(name: "admin2", uid: "xYbVyQTsJbXOnTXDh2Aw8b1VMYG2")
    static let admin3 = RoomPlayer(name: "admin3", uid: "KPXfiOZ5XxY4QHvGvYqSvaemTFj2")

    static let admin1_Cooperative =
        CooperativePlayer(name: "admin1", uid: "I1jcaAauaUQWp7uHuyMHlyDZRlP2", isRoomMaster: true)
    static let admin2_Cooperative =
        CooperativePlayer(name: "admin2", uid: "xYbVyQTsJbXOnTXDh2Aw8b1VMYG2", isRoomMaster: false)
    static let admin3_Cooperative =
        CooperativePlayer(name: "admin3", uid: "KPXfiOZ5XxY4QHvGvYqSvaemTFj2", isRoomMaster: false)
}
