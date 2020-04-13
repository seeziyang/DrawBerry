//
//  CooperativePlayer.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CooperativePlayer: ComparablePlayer, MultiplayerPlayer {
    var isRoomMaster: Bool
    private var drawingImage: UIImage?

    init(name: String, uid: String, isRoomMaster: Bool) {
        self.isRoomMaster = isRoomMaster
        super.init(name: name, uid: uid)
    }

    convenience init(from roomPlayer: RoomPlayer) {
        self.init(
            name: roomPlayer.name,
            uid: roomPlayer.uid,
            isRoomMaster: roomPlayer.isRoomMaster
        )
    }

    func addDrawing(image: UIImage) {
        drawingImage = image
    }

    func getDrawingImage() -> UIImage? {
        drawingImage
    }
}
