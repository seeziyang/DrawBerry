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

    /// Updates the drawings live according to the drawings uploaded to the database.
    func updateDrawings() {
        drawings.forEach { $0.removeFromSuperview() }
        drawings = []
        populateDrawings()
    }

    /// Populates the view with the updated drawings.
    private func populateDrawings() {
        cooperativeGame.allDrawings.forEach {
            let imageView = createImageView(of: $0, in: self.view.frame)
            drawings.append(imageView)
            view.addSubview(imageView)
        }
    }

    /// Creates an image view within a given frame from a given `UIImage`.
    private func createImageView(of image: UIImage, in frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    /// Adds the background canvas.
    private func addCanvasToView() {
        let defaultSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)

        let origin = CGPoint(x: self.view.bounds.minX, y: self.view.bounds.minY)
        let canvasBackground = UIImageView(frame: CGRect(origin: origin, size: defaultSize))
        canvasBackground.image = BerryConstants.paperBackgroundImage
        view.addSubview(canvasBackground)
    }

    /// Navigates to the end page when the last player has completed the drawing.
    func navigateToEndPage() {
        performSegue(withIdentifier: "segueToEnd", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let endVC = segue.destination as? EndViewController {
            endVC.cooperativeGame = cooperativeGame
        }
    }
}
