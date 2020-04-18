//
//  GameNetwork.swift
//  DrawBerry
//
//  Created by See Zi Yang on 14/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol GameNetwork: NetworkAdapter {
    var roomCode: RoomCode { get }

    func uploadUserDrawing(image: UIImage, forRound round: Int)

    func observeAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                         completionHandler: @escaping (UIImage) -> Void)

    func userVoteFor(playerUID: String, forRound round: Int,
                     updatedPlayerPoints: Int, updatedUserPoints: Int?)

    func observePlayerVote(playerUID: String, forRound round: Int,
                           completionHandler: @escaping (String) -> Void)

    func endGame(isRoomMaster: Bool, numRounds: Int)

    func observeAndDownloadTeamResult(playerUID: String,
                                      completionHandler: @escaping (TeamBattleTeamResult) -> Void)

    func uploadTeamResult(result: TeamBattleTeamResult)

    func getLoggedInUserID() -> String?
}
