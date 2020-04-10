//
//  TeamBattleGameViewDelegate.swift
//  DrawBerry
//
//  Created by Calvin Chen on 8/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

protocol TeamBattleGameViewDelegate: AnyObject {
    func updateDrawing(_ image: UIImage, for round: Int)
}
