//
//  TeamBattleResultDelegate.swift
//  DrawBerry
//
//  Created by Calvin Chen on 10/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

protocol TeamBattleResultDelegate: AnyObject {
    /// Handles the viewing of result after all teams results are known.
    func updateResults()
}
