//
//  Team.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

protocol Team {
    var teamID: String { get }

    var teamPlayers: [TeamBattlePlayer] { get }

    var result: TeamBattleTeamResult { get }

    var drawings: [UIImage] { get set }
}
