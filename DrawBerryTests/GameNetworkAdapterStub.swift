//
//  GameNetworkAdapterStub.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 29/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class GameNetworkAdapterStub: GameNetworkAdapter {
    override func uploadUserDrawing(image: UIImage, forRound round: Int) {
    }

    override func waitAndDownloadPlayerDrawing(playerUID: String, forRound round: Int,
                                               completionHandler: @escaping (UIImage) -> Void) {
    }
}
