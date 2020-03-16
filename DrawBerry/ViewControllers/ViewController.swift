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
        addCanvasesToView()
    }

    private func addCanvasesToView() {
        let defaultSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.height / 2)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let topLeftCanvas: Canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        self.view.addSubview(topLeftCanvas)
        let topRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.minY)
        let topRightRect = CGRect(origin: topRightOrigin, size: defaultSize)
        guard let topRightCanvas: Canvas = BerryCanvas.createCanvas(within: topRightRect) else {
            return
        }
        topRightCanvas.isClearButtonEnabled = false
        self.view.addSubview(topRightCanvas)
        let bottomLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.midY)
        let bottomLeftRect = CGRect(origin: bottomLeftOrigin, size: defaultSize)
        guard let bottomLeftCanvas: Canvas = BerryCanvas.createCanvas(within: bottomLeftRect) else {
            return
        }
        bottomLeftCanvas.isClearButtonEnabled = false
        self.view.addSubview(bottomLeftCanvas)
        let bottomRightOrigin = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        let bottomRightRect = CGRect(origin: bottomRightOrigin, size: defaultSize)
        guard let bottomRightCanvas: Canvas = BerryCanvas.createCanvas(within: bottomRightRect) else {
            return
        }
        bottomRightCanvas.isClearButtonEnabled = true
        self.view.addSubview(bottomRightCanvas)
    }
}

