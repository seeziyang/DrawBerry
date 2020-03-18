//
//  ClassGameNetworkAdapter.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FirebaseStorage

class ClassicGameNetworkAdapter {
    let roomCode: String
    let db: DatabaseReference
    let cloud: StorageReference

    init(roomCode: String) {
        self.roomCode = roomCode
        self.db = Database.database().reference()
        self.cloud = Storage.storage().reference()
    }


    // TODO: delete room from active room when game room ends
    
    func uploadUserDrawing(image: UIImage, forRound round: Int) {
        guard let imageData = image.pngData() else {
            return
        }

        let pathRef = cloud.child("activeRooms").child(roomCode).child("players")
            .child(NetworkHelper.getLoggedInUserID()).child("\(round).png")

        pathRef.putData(imageData)
    }
}
