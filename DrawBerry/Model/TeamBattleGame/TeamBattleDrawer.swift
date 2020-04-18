//
//  TeamBattleDrawer.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleDrawer: TeamBattlePlayer {

    var wordList: WordList

    init(from roomPlayer: RoomPlayer) {
        var wordBank = WordBank()
        self.wordList = wordBank.getWordList(length: TeamBattleGame.maxRounds, difficulty: .Easy)
        super.init(name: roomPlayer.name, uid: roomPlayer.uid, isRoomMaster: roomPlayer.isRoomMaster)
    }

    func getDrawingTopic() -> String {
        return wordList.getNextWord().value
    }

}
