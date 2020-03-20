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
    private var selectedColor: UIColor? {
        didSet {
            if selectedColor != nil {
                isEraserSelected = false
            }
        }
    }
    private var selectedStroke: Stroke? {
        didSet {
            if selectedStroke != nil {
                isEraserSelected = false
            }
        }
    }

    private var isEraserSelected: Bool = false {
        didSet {
            if isEraserSelected && !isEraserEnabled {
                isEraserSelected = false
            } else if isEraserSelected {
                selectedColor = nil
            }
        }
    }

    var isEraserEnabled: Bool = true {
        didSet {
            isEraserSelected = false
            deinitialiseToolViews()
            initialiseToolViews()
        }
    }

    var isUndoButtonEnabled: Bool = true {
        didSet {
            undoButton?.isEnabled = isUndoButtonEnabled
            undoButton?.isHidden = !isUndoButtonEnabled
            deinitialiseToolViews()
            initialiseToolViews()
        }
    }

    private var inks: [UIColor] = [] {
        didSet {
            deinitialiseToolViews()
            initialiseToolViews()
        }
    }

    private var strokes: [Stroke] = [] {
        didSet {
            deinitialiseToolViews()
            initialiseToolViews()
        }
    }

    private var inkViews: [InkView] = []
    private var strokeViews: [StrokeView] = []
    private var eraserView: UIImageView?
    private var eraser = PKEraserTool(PKEraserTool.EraserType.vector)
    private var undoButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        selectFirstColorFirstStroke()
    }

    required init?(coder: NSCoder) {
        nil
    }

    /// Adds a color to the palette.
    func add(color: UIColor) {
        if colorExists(color: color) {
            return
        }
        inks.append(color)
    }

    func add(stroke: Stroke) {
        if strokeExists(stroke: stroke) {
            return
        }
        strokes.append(stroke)
    }

    func selectFirstColorFirstStroke() {
        if inks.count < 1 {
            return
        }
        if strokes.count < 1 {
            return
        }
        let color = inks[0]
        selectedColor = color
        dimAllInks(except: color)
        let stroke = strokes[0]
        selectedStroke = stroke
        dimAllStrokes(except: stroke)

        selectCurrentInkTool()
    }

    func setObserver(_ newObserver: PaletteObserver) {
        observer = newObserver
    }

    func randomiseInkTool() {
        select(color: inks[Int.random(in: 0..<inks.count)], stroke: strokes[Int.random(in: 0..<strokes.count)])
    }

    func contains(tool: PKTool) -> Bool {
        if tool is PKEraserTool {
            guard let sampleEraser = tool as? PKEraserTool else {
                return false
            }
            return sampleEraser.eraserType == eraser.eraserType
        }
        if tool is PKInkingTool {
            guard let sampleInk = tool as? PKInkingTool else {
                return false
            }
            return colorExists(color: sampleInk.color) && Stroke.strokeExists(thickness: sampleInk.width)
        }
        return false
    }

    /// Initialise the tools in the palette.
    private func initialiseToolViews() {
        if isUndoButtonEnabled {
            let undoButton = createUndoButton()
            self.addSubview(undoButton)
        }
        if isEraserEnabled {
            let newEraserView = createEraserView()
            eraserView = newEraserView
            self.addSubview(newEraserView)
        }
        initialiseAllInkViews()
        initialiseAllStrokeViews()
        selectFirstColorFirstStroke()
    }

    private func initialiseAllStrokeViews() {
        let topRightCorner = CGPoint(x: bounds.width, y: bounds.height)
        var rightNeighbourOrigin = topRightCorner
        if isEraserEnabled {
            rightNeighbourOrigin = eraserView?.getOriginWithRespectToSuperview() ?? topRightCorner
        } else if isUndoButtonEnabled {
            rightNeighbourOrigin = undoButton?.getOriginWithRespectToSuperview() ?? topRightCorner
        }
        for stroke in strokes.reversed() {
            let strokeRect = getStrokeViewRect(
                within: self.bounds, rightNeighbourOrigin: rightNeighbourOrigin)
            let strokeView = StrokeView(frame: strokeRect, stroke: stroke)
            strokeView.image = BerryConstants.strokeToAsset[stroke] as? UIImage
            bindTapAction(to: strokeView)
            strokeViews.append(strokeView)
            addSubview(strokeView)
            rightNeighbourOrigin = strokeView.getOriginWithRespectToSuperview()
        }
    }

    private func initialiseAllInkViews() {
        var xDisp = CGFloat.zero
        for ink in inks {
            let inkRect = getInkViewRect(within: self.frame, horizontalDisplacement: xDisp)
            let inkView = InkView(frame: inkRect, color: ink)
            xDisp += inkView.bounds.width + BerryConstants.palettePadding
            inkView.image = BerryConstants.UIColorToAsset[ink] as? UIImage
            bindTapAction(to: inkView)
            inkViews.append(inkView)
            addSubview(inkView)
        }
    }

    private func deinitialiseToolViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
        inkViews = []
        strokeViews = []
        undoButton = nil
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
        let topRightCorner = CGPoint(x: bounds.width, y: bounds.height)
        let neighbourOrigin = isUndoButtonEnabled ? undoButton?.getOriginWithRespectToSuperview() : topRightCorner
        let eraserRect = getEraserRect(within: self.frame, rightNeighbourOrigin: neighbourOrigin ?? topRightCorner)
        let newEraserView = UIImageView(frame: eraserRect)
        newEraserView.image = BerryConstants.eraserIcon

        let newEraserTap = UITapGestureRecognizer(target: self, action: #selector(handleEraserTap))
        newEraserView.addGestureRecognizer(newEraserTap)
        newEraserView.isUserInteractionEnabled = true

        return newEraserView
    }

    /// Binds the tap action to the inkviews.
    private func bindTapAction(to inkView: InkView) {
        let touch = UITapGestureRecognizer(target: self, action: #selector(handleInkTap(recognizer:)))
        inkView.addGestureRecognizer(touch)
        inkView.isUserInteractionEnabled = true
    }

    private func bindTapAction(to strokeView: StrokeView) {
        let touch = UITapGestureRecognizer(target: self, action: #selector(handleStrokeTap(recognizer:)))
        strokeView.addGestureRecognizer(touch)
        strokeView.isUserInteractionEnabled = true
    }

    /// Selects the erasor as the selected `PKTool`.
    @objc func handleEraserTap() {
        isEraserSelected = true
        dimAllInks()
        dimAllStrokes()
        observer?.select(tool: eraser)
    }

    /// Selects the view attached to the given recognizer as the selected `PKTool`
    @objc func handleStrokeTap(recognizer: UITapGestureRecognizer) {
        guard let strokeView = recognizer.view as? StrokeView else {
            return
        }
        if isEraserSelected {
            selectFirstColorFirstStroke()
        }
        selectedStroke = strokeView.stroke
        dimAllStrokes(except: strokeView.stroke)
        selectCurrentInkTool()
    }

    /// Selects the view attached to the given recognizer as the selected `PKTool`
    @objc func handleInkTap(recognizer: UITapGestureRecognizer) {
        guard let inkView = recognizer.view as? InkView else {
            return
        }
        if isEraserSelected {
            selectFirstColorFirstStroke()
        }
        selectedColor = inkView.color
        dimAllInks(except: inkView.color)
        selectCurrentInkTool()
    }

    private func selectCurrentInkTool() {
        select(color: selectedColor ?? UIColor.black, stroke: selectedStroke ?? Stroke.thin)
    }

    /// Sets the selected ink color to the given color.
    private func select(color: UIColor, stroke: Stroke) {
        let inkTool = createInkTool(with: color, stroke: stroke)
        observer?.select(tool: inkTool)
    }

    /// Dims all the `InkView`s
    private func dimAllInks() {
        inkViews.forEach { $0.alpha = BerryConstants.unselectedOpacity }
    }

    /// Dims all the `InkView`s except the `InkView` corresponding to the given `UIColor`.
    private func dimAllInks(except selected: UIColor) {
        inkViews.forEach {
            $0.alpha = $0.color == selected ? BerryConstants.fullOpacity : BerryConstants.unselectedOpacity
        }
    }

    /// Dims all the `StrokeView`s.
    private func dimAllStrokes() {
        strokeViews.forEach { $0.alpha = BerryConstants.unselectedOpacity }
    }

    /// Dims all the `InkView`s except the `InkView` corresponding to the given `UIColor`.
    private func dimAllStrokes(except selected: Stroke) {
        strokeViews.forEach {
            $0.alpha = $0.stroke == selected ? BerryConstants.fullOpacity : BerryConstants.unselectedOpacity
        }
        strokeViews.forEach {
            $0.image = $0.stroke == selected
                ? BerryConstants.selectedStrokeToAsset[$0.stroke] as? UIImage
                : BerryConstants.strokeToAsset[$0.stroke] as? UIImage
        }
    }

    /// Returns true if the given `UIColor` exists in the  `BerryPalette`.
    private func colorExists(color: UIColor) -> Bool {
        inks.filter { color == $0 }.count >= 1
    }

    /// Returns true if the given `UIColor` exists in the  `BerryPalette`.
    private func strokeExists(stroke: Stroke) -> Bool {
        strokes.filter { stroke == $0 }.count >= 1
    }

    /// Creates a `PKInkingTool` that corresponds to the given `UIColor`.
    private func createInkTool(with color: UIColor, stroke: Stroke) -> PKInkingTool {
        let defaultInkType = PKInkingTool.InkType.pen
        return PKInkingTool(defaultInkType, color: color, width: stroke.rawValue)
    }

    /// Returns the `CGRect` for the `InkView` given the bounds and the horizontal displacement.
    private func getInkViewRect(within bounds: CGRect, horizontalDisplacement: CGFloat) -> CGRect {
        let size = CGSize(width: BerryConstants.toolLength, height: BerryConstants.toolLength)
        let origin = CGPoint(
            x: horizontalDisplacement + BerryConstants.palettePadding,
            y: BerryConstants.palettePadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the `StrokeView` given the bounds and the origin of the right UI element.
    private func getStrokeViewRect(within bounds: CGRect, rightNeighbourOrigin: CGPoint) -> CGRect {
        let size = CGSize(width: BerryConstants.strokeWidth, height: BerryConstants.strokeLength)
        let origin = CGPoint(
            x: rightNeighbourOrigin.x - BerryConstants.strokeWidth - BerryConstants.palettePadding,
            y: BerryConstants.palettePadding)
        return CGRect(origin: origin, size: size)
    }

    /// Returns the `CGRect` for the eraser view given the bounds and the origin of the right UI element.
    private func getEraserRect(within bounds: CGRect, rightNeighbourOrigin: CGPoint) -> CGRect {
        let size = CGSize(width: BerryConstants.toolLength, height: BerryConstants.toolLength)
        let origin = CGPoint(
            x: rightNeighbourOrigin.x - BerryConstants.toolLength - BerryConstants.canvasPadding,
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

extension UIView {
    func getOriginWithRespectToSuperview() -> CGPoint {
        return CGPoint( x: self.center.x - (self.bounds.width / 2), y: self.center.y - (self.bounds.height / 2))
    }
}
