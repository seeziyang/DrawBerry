//
//  ClassGameNetworkAdapter.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import Firebase
import FirebaseStorage

class FirebaseGameNetworkAdapter: GameNetwork {
    let roomCode: RoomCode
    let db: DatabaseReference
    let cloud: StorageReference

    init(roomCode: RoomCode) {
        self.roomCode = roomCode
        self.db = Database.database().reference()
        self.cloud = Storage.storage().reference()
    }

    func uploadUserDrawing(image: UIImage, forRound round: Int) {
        guard let imageData = image.pngData(),
            let userID = NetworkHelper.getLoggedInUserID() else {
                return
        }

        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .child("rounds")
            .child("round\(round)")
            .child("hasUploadedImage")

        let cloudPathRef = cloud.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .child("\(round).png")

        cloudPathRef.putData(imageData, metadata: nil, completion: { _, error in
            if let error = error {
                // TODO: Handle error, count as player left?
                print("Error \(error) occured while uploading user drawing to CloudStorage")
                return
            }

            dbPathRef.setValue(true)
        })

        updateCurrRound(prevRound: round)
    }

    private func updateCurrRound(prevRound round: Int) {
        guard let userID = NetworkHelper.getLoggedInUserID() else {
            return
        }

        let dbRoomPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)

        // if is last player to draw, update currRound in db to next round
        dbRoomPathRef.child("players")
            .observeSingleEvent(of: .value, with: { snapshot in
                // [playerUID: [rounds: Any]]
                guard var otherPlayersValues = snapshot.value as? [String: [String: Any]] else {
                    return
                }

                otherPlayersValues[userID] = nil // remove user from dictionary

                // [playerUID: [roundNumber: [hasUploadedImage: Any]]]
                guard let otherPlayerRounds = otherPlayersValues.mapValues({ $0["rounds"] })
                    as? [String: [String: [String: Any]]] else {
                        // not everyone else has drawn in first round yet
                        return
                }

                // does not contain another player that has not drawn
                let isUserLastDrawer = !otherPlayerRounds.contains(where: { _, rounds in
                    rounds["round\(round)"]?["hasUploadedImage"] == nil
                })

                if isUserLastDrawer {
                    dbRoomPathRef.child("currRound")
                        .setValue(round + 1)
                }
            })
    }

    private func downloadPlayerDrawing(playerUID: String, forRound round: Int,
                                       completionHandler: @escaping (UIImage) -> Void) {
        let cloudPathRef = cloud.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(playerUID)
            .child("\(round).png")

        cloudPathRef.getData(maxSize: 10 * 1_024 * 1_024, completion: { data, error in
            if let error = error {
                print("Error \(error) occured while downloading player drawing")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                return
            }

            completionHandler(image)
        })
    }

    func observeAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                         completionHandler: @escaping (UIImage) -> Void) {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(playerUID)
            .child("rounds")
            .child("round\(round)")
            .child("hasUploadedImage")

        dbPathRef.observe(.value, with: { snapshot in
            guard snapshot.value as? Bool ?? false else { // image not uploaded yet
                return
            }

            self.downloadPlayerDrawing(playerUID: playerUID, forRound: round,
                                       completionHandler: completionHandler)

            dbPathRef.removeAllObservers() // remove observer after downloading image
        })
    }

    func userVoteFor(playerUID: String, forRound round: Int,
                     updatedPlayerPoints: Int, updatedUserPoints: Int? = nil) {
        guard let userID = NetworkHelper.getLoggedInUserID() else {
            return
        }

        let dbRoomPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)

        dbRoomPathRef.child("players")
            .child(userID)
            .child("rounds")
            .child("round\(round)")
            .child("votedFor")
            .setValue(playerUID)

        // update other player's points in db
        dbRoomPathRef.child("players")
            .child(playerUID)
            .child("points")
            .setValue(updatedPlayerPoints)

        // update user's points in db
        if let updatedUserPoints = updatedUserPoints {
            dbRoomPathRef.child("players")
                .child(userID)
                .child("points")
                .setValue(updatedUserPoints)
        }
    }

    func observePlayerVote(playerUID: String, forRound round: Int,
                           completionHandler: @escaping (String) -> Void) {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(playerUID)
            .child("rounds")
            .child("round\(round)")
            .child("votedFor")

        dbPathRef.observe(.value, with: { snapshot in
            guard let votedForPlayerUID = snapshot.value as? String else {
                return
            }

            completionHandler(votedForPlayerUID)

            dbPathRef.removeAllObservers()
        })
    }

    func endGame(isRoomMaster: Bool, numRounds: Int) {
        guard let userID = NetworkHelper.getLoggedInUserID() else {
            return
        }

        // room master deletes active room from db
        if isRoomMaster {
            db.child("activeRooms")
                .child(roomCode.type.rawValue)
                .child(roomCode.value)
                .removeValue()
        }

        let cloudPathRef = cloud.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)

        // delete drawing for each round from storage
        for round in 0..<numRounds {
            cloudPathRef.child("\(round).png").delete()
        }
    }

    func observeAndDownloadTeamResult(playerUID: String,
                                      completionHandler: @escaping (TeamBattleTeamResult) -> Void) {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(playerUID)
            .child("hasTeamResult")

        dbPathRef.observe(.value, with: { snapshot in
            guard snapshot.value as? Bool ?? false else { // result not ready
                return
            }

            self.downloadTeamResult(playerUID: playerUID, completionHandler: completionHandler)

            //dbPathRef.remove// remove observer after downloading image
        })
    }

    private func downloadTeamResult(playerUID: String, completionHandler: @escaping (TeamBattleTeamResult) -> Void) {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(playerUID)
            .child("teamResult")

        dbPathRef.observe(.value, with: { snapshot in
            guard let databaseDescription = snapshot.value as? String else { // result not ready
                return
            }

            guard let result = TeamBattleTeamResult(databaseDescription: databaseDescription) else {
                return
            }

            completionHandler(result)

            // dbPathRef.removeAllObservers() // remove observer after downloading image
        })
    }

    func uploadTeamResult(result: TeamBattleTeamResult) {
        let dbPathRef = db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(result.resultID)

        dbPathRef.child("teamResult").setValue(result.getDatabaseStorageDescription())
        dbPathRef.child("hasTeamResult").setValue(true)
    }
}
