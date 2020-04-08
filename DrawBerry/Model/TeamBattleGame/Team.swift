//
//  Team.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol Team {
    var teamID: String { get }

    var teamPlayers: [TeamBattlePlayer] { get }

    var result: TeamBattleGameResult { get }
}
