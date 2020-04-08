//
//  TeamBattleGuesser.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

class TeamBattleGuesser: TeamBattlePlayer {

//    convenience init(from roomPlayer: RoomPlayer) {
//        self.init(name: roomPlayer.name, uid: roomPlayer.uid, isRoomMaster: roomPlayer.isRoomMaster)
//    }

    func getDrawingTopic() -> String {
        // TODO: use network
        return "apple"
    }

    func getLengthHint() -> Int {
        return getDrawingTopic().count
    }

    func isGuessCorrect(guess: String) -> Bool {
        return guess == getDrawingTopic()
    }

}
