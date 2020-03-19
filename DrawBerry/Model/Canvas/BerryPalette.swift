//
//  BerryPalette.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 13/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit
import PencilKit

class BerryPalette: UIView {
    private var observer: PaletteObserver?
    var selectedInkTool: PKInkingTool? {
        didSet {
            if selectedInkTool != nil {
                isEraserSelected = false
            }
        }
    }

    var isEraserSelected: Bool = false {
        didSet {
            if isEraserSelected {
                selectedInkTool = nil
            }
        }
    }

    var isUndoButtonEnabled: Bool = true {
        didSet {
            undoButton?.isEnabled = isUndoButtonEnabled
            undoButton?.isHidden = !isUndoButtonEnabled
        }
    }

    private var inks: [PKInkingTool] = [] {
        didSet {
            deinitialiseToolViews()
            initialiseToolViews()
        }
    }

    private var inkViews: [InkView] = []
    private var eraserView: UIImageView?
    private var eraser = PKEraserTool(PKEraserTool.EraserType.vector)
    private var undoButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        selectedInkTool = getInkingToolFrom(color: UIColor.black)
    }

    required init?(coder: NSCoder) {
        nil
    }

    /// Adds a color to the palette.
    func add(color: UIColor) {
        if colorExists(color: color) {
            return
        }
        let newInkTool = createInkTool(with: color)
        inks.append(newInkTool)
    }

    /// Selects the first color in the palette.
    func selectFirstColor() {
        if inks.count < 1 {
            return
        }
        select(color: inks[0].color)
    }

    func setObserver(_ newObserver: PaletteObserver) {
        observer = newObserver
    }

    /// Initialise the tools in the palette.
    private func initialiseToolViews() {
        var xDisp = CGFloat.zero
        for ink in inks {
            let inkView = InkView(
                frame: getInkViewRect(within: self.frame, horizontalDisplacement: xDisp), color: ink.color)
            xDisp += inkView.bounds.width + BerryConstants.palettePadding
            inkView.image = UIImage(named: BerryConstants.UIColorToAssetName[ink.color] ?? "black")
            bindTapAction(to: inkView)
            inkViews.append(inkView)
            addSubview(inkView)
        }

        let newEraserView = createEraserView()
        eraserView = newEraserView
        self.addSubview(newEraserView)
        let undoButton = createUndoButton()
        self.addSubview(undoButton)
    }

    private func deinitialiseToolViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
        inkViews = []
        eraserView = nil
    }

    private func createUndoButton() -> UIButton {
        let button = UIButton(frame: getUndoButtonRect(within: self.bounds))
        let icon = BerryConstants.deleteIcon
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(undoButtonTap), for: .touchDown)
        undoButton = button
        return button
    }

    /// Undo the drawing one stroke before when the undo button is tapped.
    @objc func undoButtonTap() {
        observer?.undo()
    }

    /// Creates the eraser view.
    private func createEraserView() -> UIImageView {
        let newEraserView = UIImageView(frame: getEraserRect(within: self.frame))
        newEraserView.image = BerryConstants.eraserIcon

        let newEraserTap = UITapGestureRecognizer(target: self, action: #selector(handleEraserTap))
        newEraserView.addGestureRecognizer(newEraserTap)
        newEraserView.isUserInteractionEnabled = true

        return newEraserView
    }

    /// Binds the tap action to the inkviews.
    private func bindTapAction(to inkView: InkView) {
        let touch = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        inkView.addGestureRecognizer(touch)
        inkView.isUserInteractionEnabled = true
    }

    /// Selects the erasor as the selected `PKTool`.
    @objc func handleEraserTap() {
        isEraserSelected = true
        dimAllInks()
        observer?.select(tool: eraser)
    }

    /// Selects the view attached to the given recognizer as the selected `PKTool`
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        guard let inkView = recognizer.view as? InkView else {
            return
        }
        select(color: inkView.color)
    }

    /// Sets the selected ink color to the given color.
    func select(color: UIColor) {
        guard let inkView = getInkViewFrom(color: color) else {
            return
        }
        guard let currentSelectedInkTool = getInkingToolFrom(color: inkView.color) else {
            return
        }
        selectedInkTool = currentSelectedInkTool
        inkView.alpha = 1
        dimAllInks(except: inkView.color)
        observer?.select(tool: currentSelectedInkTool)
    }

    /// Returns an `InkView` given a `UIColor`.
    private func getInkViewFrom(color: UIColor) -> InkView? {
        let inkView = inkViews.filter { $0.color == color }
        return inkView.count != 1 ? nil : inkView[0]
    }

    /// Returns a  `PKInkingTool` from a given `UIColor`.
    private func getInkingToolFrom(color: UIColor) -> PKInkingTool? {
        let tool = inks.filter { $0.color == color }
        return tool.count != 1 ? nil : tool[0]
    }

    /// Dims all the `InkView`s except the `InkView` corresponding to the given `UIColor`.
    private func dimAllInks(except selected: UIColor) {
        inkViews.filter { $0.color != selected }.forEach { $0.alpha = BerryConstants.halfOpacity }
    }

    private func dimAllInks() {
        inkViews.forEach { $0.alpha = BerryConstants.halfOpacity }
    }

    /// Brightens all the `InkView`s.
    private func brightenAllInks() {
        inkViews.forEach { $0.alpha = BerryConstants.fullOpacity }
    }

    /// Returns true if the given `UIColor` exists in the  `BerryPalette`.
    private func colorExists(color: UIColor) -> Bool {
        inks.map { $0.color }.filter { color == $0 }.count >= 1
    }

    /// Creates a `PKInkingTool` that corresponds to the given `UIColor`.
    private func createInkTool(with color: UIColor) -> PKInkingTool {
        let defaultInkType = PKInkingTool.InkType.pen
        return PKInkingTool(defaultInkType, color: color, width: BerryConstants.defaultInkWidth)
    }

    /// Returns the `CGRect` for the `InkView` given the bounds and the horizontal displacement.
    private func getInkViewRect(within bounds: CGRect, horizontalDisplacement: CGFloat) -> CGRect {
        let size = CGSize(width: BerryConstants.toolLength, height: BerryConstants.toolLength)
        let origin = CGPoint(
            x: horizontalDisplacement + BerryConstants.palettePadding,
            y: BerryConstants.palettePadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the eraser view given the bounds.
    private func getEraserRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: BerryConstants.toolLength, height: BerryConstants.toolLength)
        let origin = CGPoint(
            x: bounds.width - (BerryConstants.palettePadding * 2) - (BerryConstants.toolLength * 2),
            y: BerryConstants.palettePadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the undo button given the bounds.
    private func getUndoButtonRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: BerryConstants.buttonRadius, height: BerryConstants.buttonRadius)
        let origin = CGPoint(
            x: bounds.width - BerryConstants.buttonRadius - BerryConstants.canvasPadding,
            y: BerryConstants.canvasPadding)
        return CGRect(origin: origin, size: size)
    }
}
