//
//  TeamBattleDrawer.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TeamBattleDrawer: TeamBattlePlayer {

    private var wordBank: WordBank
    private var drawingImages: [UIImage] = []

    init(from roomPlayer: RoomPlayer) {
        self.wordBank = WordBank()
        super.init(name: roomPlayer.name, uid: roomPlayer.uid, isRoomMaster: roomPlayer.isRoomMaster)
    }

    func getDrawingTopic() -> String {
        guard let topic = wordBank.getRandomWord(difficulty: .Easy)?.value else {
            wordBank.reloadWordBank()
            return wordBank.getWordWhenEmptyWordBank().value
        }

        return topic
    }

    func addDrawing(image: UIImage) {
        drawingImages.append(image)
    }

    func getDrawingImage() -> UIImage? {
        getDrawingImage(ofRound: 1)
    }

    func getDrawingImage(ofRound round: Int) -> UIImage? {
        let index = round - 1
        return drawingImages[index]
    }

}
