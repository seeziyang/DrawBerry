//
//  CooperativePlayer.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CooperativePlayer: MultiplayerPlayer {
    let name: String
    let uid: String
    var isRoomMaster: Bool
    private var drawingImage: UIImage?

    init(name: String, uid: String, isRoomMaster: Bool) {
        self.name = name
        self.uid = uid
        self.isRoomMaster = isRoomMaster
    }

    required convenience init(from roomPlayer: RoomPlayer) {
        self.init(
            name: roomPlayer.name,
            uid: roomPlayer.uid,
            isRoomMaster: roomPlayer.isRoomMaster
        )
    }

    /// Adds a drawing to the player.
    func addDrawing(image: UIImage) {
        drawingImage = image
    }

    /// Returns the drawing of the player.
    func getDrawingImage() -> UIImage? {
        drawingImage
    }
}
