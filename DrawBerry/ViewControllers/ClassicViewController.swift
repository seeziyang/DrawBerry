//
//  ClassicViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 10/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

// TODO: rename topLeftCanvas to just canvas since classic game only one canvas
class ClassicViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCanvasesToView()
    }

    private func addCanvasesToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let topLeftCanvas: Canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        topLeftCanvas.isClearButtonEnabled = true
        topLeftCanvas.isUndoButtonEnabled = true
        topLeftCanvas.delegate = self
        self.view.addSubview(topLeftCanvas)
    }
}
