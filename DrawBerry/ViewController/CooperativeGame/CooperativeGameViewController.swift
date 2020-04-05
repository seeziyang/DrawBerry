//
//  CooperativeGameViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 29/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class CooperativeGameViewController: CanvasDelegateViewController {
    var canvasHeight: CGFloat {
        self.view.bounds.height - BerryConstants.paletteHeight
    }
    var canvasWidth: CGFloat {
        self.view.bounds.width
    }
}
