//
//  CooperativePlayer.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class CooperativePlayer: ComparablePlayer {
    var index: Int
    var isRoomMaster: Bool
    private var drawingImage: UIImage?

    init(name: String, uid: String, isRoomMaster: Bool, index: Int) {
        self.isRoomMaster = isRoomMaster
        self.index = index
        super.init(name: name, uid: uid)
    }

    convenience init(from roomPlayer: RoomPlayer, index: Int) {
        self.init(
            name: roomPlayer.name,
            uid: roomPlayer.uid,
            isRoomMaster: roomPlayer.isRoomMaster,
            index: index
        )
    }

    func addDrawing(image: UIImage) {
        drawingImage = image
    }

    func getDrawingImage() -> UIImage? {
        drawingImage
    }
}
