//
//  ClassicPlayer.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicPlayer: ComparablePlayer {
    var isRoomMaster: Bool
    var points: Int
    private var drawingImages: [UIImage]
    private var votedPlayers: [ClassicPlayer]

    init(name: String, uid: String, isRoomMaster: Bool, points: Int = 0) {
        self.isRoomMaster = isRoomMaster
        self.points = points
        self.drawingImages = []
        self.votedPlayers = []
        super.init(name: name, uid: uid)
    }

    convenience init(from roomPlayer: RoomPlayer) {
        self.init(name: roomPlayer.name, uid: roomPlayer.uid, isRoomMaster: roomPlayer.isRoomMaster)
    }

    func addDrawing(image: UIImage) {
        drawingImages.append(image)
    }

    func getDrawingImage() -> UIImage? {
        getDrawingImage(ofRound: 1)
    }

    func getDrawingImage(ofRound round: Int) -> UIImage? {
        guard hasDrawing(ofRound: round) else {
            return nil
        }

        let index = round - 1
        return drawingImages[index]
    }

    func hasDrawing(ofRound round: Int) -> Bool {
        if drawingImages.isEmpty {
            return false
        }

        let index = round - 1
        return index >= 0 && index < drawingImages.count
    }

    func voteFor(player: ClassicPlayer) {
        votedPlayers.append(player)
    }

    func hasVoted(inRound round: Int) -> Bool {
        if votedPlayers.isEmpty {
            return false
        }

        let index = round - 1
        return index >= 0 && index < votedPlayers.count
    }

    func getVotedPlayer(inRound round: Int) -> ClassicPlayer? {
        guard hasVoted(inRound: round) else {
            return nil
        }

        let index = round - 1
        return votedPlayers[index]
    }
}
