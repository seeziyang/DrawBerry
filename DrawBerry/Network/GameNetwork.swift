//
//  GameNetwork.swift
//  DrawBerry
//
//  Created by See Zi Yang on 14/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol GameNetwork: NetworkInterface {
    var roomCode: RoomCode { get }

    func uploadUserDrawing(image: UIImage, forRound round: Int)

    func observeAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                         completionHandler: @escaping (UIImage) -> Void)

    func userVoteFor(playerUID: String, forRound round: Int,
                     updatedPlayerPoints: Int, updatedUserPoints: Int?)

    func observePlayerVote(playerUID: String, forRound round: Int,
                           completionHandler: @escaping (String) -> Void)

    func observeValue(key: String, playerUID: String,
                            completionHandler: @escaping (String) -> Void)

    func uploadKeyValuePair(key: String, playerUID: String, value: String)

    func endGame(isRoomMaster: Bool, numRounds: Int)

    func getLoggedInUserID() -> String?

    func setTopic(topic: String, forRound round: Int)

    func observeTopic(forRound round: Int, completionHandler: @escaping (String) -> Void)
}
