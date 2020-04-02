//
//  DrawingViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

class DrawingViewController: CooperativeGameViewController {
    var cooperativeGame: CooperativeGame!
    var canvas: Canvas!
    var drawingSpaceHeight: CGFloat {
        canvasHeight / CGFloat(cooperativeGame.players.count)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCanvasToView()
        addPreviousDrawings()
        createMask()
        addDoneButtonToView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewingVC = segue.destination as? ViewingViewController {
            viewingVC.cooperativeGame = cooperativeGame
            viewingVC.cooperativeGame.viewingDelegate = viewingVC
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
        view.addSubview(canvas)
        self.canvas = canvas
    }

    private func addDoneButtonToView() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 250,
                              width: 100, height: 50)
        button.backgroundColor = .systemYellow
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneOnTap(sender:)), for: .touchUpInside)

        view.addSubview(button)
    }

    @objc private func doneOnTap(sender: UIButton) {
        finishRound()
    }

    private func finishRound() {
        cooperativeGame.addUsersDrawing(image: canvas.drawingImage)
        performSegue(withIdentifier: "segueToViewing", sender: self)
    }

    private func addPreviousDrawings() {
        cooperativeGame.allDrawings.forEach {
            let imageView = UIImageView(frame: canvas.frame)
            imageView.image = $0
            view.addSubview(imageView)
        }
    }

    private func createMask() {
        let drawingSpaceOrigin = CGPoint(x: 0, y: CGFloat(cooperativeGame.userIndex) * drawingSpaceHeight)
        canvas.drawableArea = CGRect(
            x: drawingSpaceOrigin.x,
            y: drawingSpaceOrigin.y,
            width: canvasWidth,
            height: drawingSpaceHeight
        )
        let firstMask = UIView(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: drawingSpaceOrigin.y))
        firstMask.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        firstMask.alpha = 0.5

        let firstMaskOpaque =
            UIView(frame: CGRect(x: 0, y: 0, width: canvasWidth, height: drawingSpaceOrigin.y - 50))
        firstMaskOpaque.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        firstMaskOpaque.alpha = 1

        let secondMask = UIView(frame:
            CGRect(
                x: 0,
                y: drawingSpaceOrigin.y + drawingSpaceHeight,
                width: canvasWidth,
                height: canvasHeight - firstMask.bounds.height - drawingSpaceHeight)
        )
        secondMask.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        secondMask.alpha = 0.5
        view.addSubview(firstMaskOpaque)
        view.addSubview(firstMask)
        view.addSubview(secondMask)
    }
}
