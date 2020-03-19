//
//  ClassicPlayer.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ClassicPlayer: Player {
    let name: String
    let uid: String
    var isRoomMaster: Bool
    var points: Int
    private var drawingImages: [UIImage]

    init(name: String, uid: String, isRoomMaster: Bool) {
        self.name = name
        self.uid = uid
        self.isRoomMaster = isRoomMaster
        self.points = 0
        self.drawingImages = []
    }

    convenience init(from roomPlayer: RoomPlayer) {
        self.init(name: roomPlayer.name, uid: roomPlayer.uid, isRoomMaster: roomPlayer.isRoomMaster)
    }

    func addDrawing(image: UIImage) {
        drawingImages.append(image)
    }

    func getDrawingImage(ofRound round: Int) -> UIImage? {
        if drawingImages.isEmpty {
            return nil
        }

        let index = round - 1
        if index >= drawingImages.count && index < 0 {
            return nil
        } else {
            return drawingImages[index]
        }
    }
}
