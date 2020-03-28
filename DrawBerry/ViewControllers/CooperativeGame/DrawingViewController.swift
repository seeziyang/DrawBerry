//
//  DrawingViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

class DrawingViewController: CanvasDelegateViewController {
    var cooperativeGame: CooperativeGame!
    var canvas: Canvas!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCanvasToView()
        addDoneButtonToView()
        createMask()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let waitingVC = segue.destination as? WaitingViewController {
            waitingVC.cooperativeGame = cooperativeGame
            waitingVC.cooperativeGame.delegate = waitingVC
        }
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let topLeftOrigin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let topLeftRect = CGRect(origin: topLeftOrigin, size: defaultSize)
        guard let canvas = BerryCanvas.createCanvas(within: topLeftRect) else {
            return
        }
        canvas.isClearButtonEnabled = true
        canvas.isUndoButtonEnabled = true
        canvas.delegate = self
        self.view.addSubview(canvas)
        self.canvas = canvas
    }

    private func addDoneButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 250,
                              width: 100, height: 50)
        button.backgroundColor = .systemYellow
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneOnTap(sender:)), for: .touchUpInside)

        self.view.addSubview(button)
    }

    @objc private func doneOnTap(sender: UIButton) {
        finishRound()
    }

    private func finishRound() {
        cooperativeGame.addUsersDrawing(image: canvas.drawingImage)
        performSegue(withIdentifier: "segueToViewing", sender: self)
    }

    private func createMask() {
        let canvasHeight = canvas.bounds.height - BerryConstants.paletteHeight
        let canvasWidth = canvas.bounds.width

        let drawingSpaceHeight = canvasHeight / CGFloat(cooperativeGame.players.count)
        let drawingSpaceOrigin = CGPoint(x: 0, y: CGFloat(cooperativeGame.userIndex) * drawingSpaceHeight)
        let firstMask = UIView(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: drawingSpaceOrigin.y))
        firstMask.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        firstMask.alpha = 0.5

        let secondMask = UIView(frame:
            CGRect(
                x: 0,
                y: drawingSpaceOrigin.y + drawingSpaceHeight,
                width: canvasWidth,
                height: canvasHeight - firstMask.bounds.height - drawingSpaceHeight)
        )
        secondMask.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        secondMask.alpha = 0.5
        firstMask.layer.borderWidth = 10
        firstMask.layer.borderColor = UIColor.red.cgColor
        secondMask.layer.borderWidth = 10
        secondMask.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(firstMask)
        self.view.addSubview(secondMask)
    }
}
