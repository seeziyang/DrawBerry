//
//  ViewController.swift
//  DrawBerry
//
//  Created by Jon Chua on 10/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCanvasToView()
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height / 2)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let topLeftCanvas = ClassicCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        self.view.addSubview(topLeftCanvas)
        let topRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.minY)
        let topRightRect = CGRect(origin: topRightOrigin, size: defaultSize)
        guard let topRightCanvas = ClassicCanvas.createCanvas(within: topRightRect) else {
            return
        }
        self.view.addSubview(topRightCanvas)
    }
}

