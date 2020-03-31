//
//  ViewingViewController.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 26/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import Firebase

class ViewingViewController: CooperativeGameViewController, CooperativeGameViewingDelegate {
    private var drawings: [UIImageView] = []
    var drawingSpaceHeight: CGFloat {
        canvasHeight / CGFloat(cooperativeGame.players.count)
    }

    var cooperativeGame: CooperativeGame!

    override func viewDidLoad() {
        super.viewDidLoad()
        addCanvasToView()
        populateDrawings()
        cooperativeGame.downloadSubsequentDrawings()
        overrideUserInterfaceStyle = .light
    }

    func updateDrawings() {
        drawings.forEach { $0.removeFromSuperview() }
        drawings = []
        populateDrawings()
    }

    private func populateDrawings() {
        cooperativeGame.allDrawings.forEach {
            let yDisp = (drawings.last?.bounds.origin.y ?? -drawingSpaceHeight) + drawingSpaceHeight
            let frame = CGRect(x: 0, y: yDisp, width: canvasWidth, height: drawingSpaceHeight)
            let imageView = createImageView(of: $0, in: frame)
            drawings.append(imageView)
            view.addSubview(imageView)
        }
    }

    private func updateNextDrawing() {
        guard let lastDrawing = cooperativeGame.allDrawings.last else {
            return
        }
        let yDisp = (drawings.last?.bounds.origin.y ?? 0) + drawingSpaceHeight
        let frame = CGRect(x: 0, y: yDisp, width: canvasWidth, height: canvasHeight)
        let imageView = createImageView(of: lastDrawing, in: frame)
        drawings.append(imageView)
        view.addSubview(imageView)
    }

    private func createImageView(of image: UIImage, in frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        return imageView
    }

    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        view.addSubview(canvasBackground)
    }

    func navigateToEndPage() {
        performSegue(withIdentifier: "segueToEnd", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let endVC = segue.destination as? EndViewController {
            endVC.cooperativeGame = cooperativeGame
        }
    }
}
