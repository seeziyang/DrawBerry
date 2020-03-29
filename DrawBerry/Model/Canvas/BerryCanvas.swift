//
//  BerryCanvas.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 11/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import PencilKit

class BerryCanvas: UIView, UIGestureRecognizerDelegate, PaletteObserver, Canvas {
    weak var delegate: CanvasDelegate?
    var isAbleToDraw = true {
        didSet {
            if !isAbleToDraw {
                drawingCanvas.drawingGestureRecognizer.state = .ended
            }
            drawingCanvas.drawingGestureRecognizer.isEnabled = isAbleToDraw
        }
    }

    var tool: PKTool {
        drawingCanvas.tool
    }

    var drawableArea: CGRect?
    private var drawingCanvas: PKCanvasView
    private let palette: Palette
    private var clearButton: UIButton

    var currentCoordinate: CGPoint? {
        let currentState = drawingCanvas.drawingGestureRecognizer.state
        if currentState == .possible || currentState == .began || currentState == .changed {
            return drawingCanvas.drawingGestureRecognizer.location(in: drawingView)
        }
        return nil
    }

    var isClearButtonEnabled: Bool {
        didSet {
            clearButton.isEnabled = isClearButtonEnabled
            clearButton.isHidden = !isClearButtonEnabled
        }
    }

    var isUndoButtonEnabled: Bool = true {
        didSet {
            palette.isUndoButtonEnabled = isUndoButtonEnabled
        }
    }

    var isEraserEnabled: Bool = true {
        didSet {
            palette.isEraserEnabled = isEraserEnabled
        }
    }

    var drawing: PKDrawing {
        drawingCanvas.drawing
    }

    var history: [PKDrawing] = []
    var numberOfStrokes: Int = 0

    var drawingView: UIView? {
        let nestedSubviews = drawingCanvas.subviews.map { $0.subviews }
        var allSubviews: [UIView] = []
        nestedSubviews.forEach { allSubviews += $0 }
        let dgrView = allSubviews.filter { $0 == drawingCanvas.drawingGestureRecognizer.view }
        if dgrView.count != 1 {
            return nil
        }
        return dgrView[0]
    }

    func undo() {
        drawingCanvas.drawing = PKDrawing().appending(delegate?.undo(on: self) ?? PKDrawing())
    }

    /// Creates a `Canvas` with the given bounds.
    static func createCanvas(within bounds: CGRect) -> Canvas? {
        if outOfBounds(bounds: bounds) {
            return nil
        }
        return BerryCanvas(frame: bounds)
    }

    /// Sets the `PKTool` of the canvas to the given tool if the `PKTool` exists in the `Palette`.
    func select(tool: PKTool) {
        if !palette.contains(tool: tool) {
            return
        }
        drawingCanvas.tool = tool
    }

    func randomiseInkTool() {
        palette.randomiseInkTool()
    }

    /// Checks if the given bounds is within the acceptable bounds.
    private static func outOfBounds(bounds: CGRect) -> Bool {
        bounds.width < BerryConstants.minimumCanvasWidth || bounds.height < BerryConstants.minimumCanvasHeight
    }

    override private init(frame: CGRect) {
        palette = BerryCanvas.createPalette(within: frame)
        drawingCanvas = BerryCanvas.createCanvasView(within: frame)
        clearButton = BerryCanvas.createClearButton(within: frame)
        isClearButtonEnabled = true

        super.init(frame: frame)
        palette.setObserver(self)
        palette.selectFirstColorFirstStroke()
        bindGestureRecognizers()
        addComponentsToCanvas()
    }

    required init?(coder: NSCoder) {
        nil
    }

    /// Binds the required gesture recognizers to the views in the `BerryCanvas`.
    private func bindGestureRecognizers() {
        clearButton.addTarget(self, action: #selector(clearButtonTap), for: .touchUpInside)
        let draw = UIPanGestureRecognizer(target: self, action: #selector(handleDraw(recognizer:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        draw.delegate = self
        tap.delegate = self
        drawingView?.addGestureRecognizer(draw)
        drawingView?.addGestureRecognizer(tap)
    }

    /// Tracks the state of the drawing and update the history when the stroke has ended.
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        delegate?.handleDraw(recognizer: recognizer, canvas: self)
    }

    /// Tracks the state of the drawing and update the history when the stroke has ended.
    @objc func handleDraw(recognizer: UIPanGestureRecognizer) {
        delegate?.handleDraw(recognizer: recognizer, canvas: self)
    }

    /// Populate the canvas with the required components.
    private func addComponentsToCanvas() {
        let background = BerryCanvas.createBackground(within: frame)
        addSubview(background)
        addSubview(drawingCanvas)
        if let paletteView = palette as? UIView {
            addSubview(paletteView)
        }
        addSubview(clearButton)
    }

    /// Creates the background with the given bounds.
    private static func createBackground(within bounds: CGRect) -> UIView {
        let background = UIImageView(frame: getBackgroundRect(within: bounds))
        background.image = BerryConstants.paperBackgroundImage
        return background
    }

    /// Creates the canvas view with the given bounds.
    private static func createCanvasView(within bounds: CGRect) -> PKCanvasView {
        let newCanvasView = PKCanvasView(frame: getCanvasRect(within: bounds))
        newCanvasView.allowsFingerDrawing = true
        newCanvasView.isOpaque = false
        newCanvasView.isUserInteractionEnabled = true
        return newCanvasView
    }

    /// Creates the palette with the given bounds.
    private static func createPalette(within bounds: CGRect) -> BerryPalette {
        let newPalette = BerryPalette(frame: getPalatteRect(within: bounds))
        initialise(palette: newPalette)
        return newPalette
    }

    /// Initialises the palette with the default colors.
    private static func initialise(palette: BerryPalette) {
        palette.add(color: BerryConstants.berryBlack)
        palette.add(color: BerryConstants.berryBlue)
        palette.add(color: BerryConstants.berryRed)
        palette.add(stroke: Stroke.thin)
        palette.add(stroke: Stroke.medium)
        palette.add(stroke: Stroke.thick)
        palette.selectFirstColorFirstStroke()
    }

    /// Creates the clear button with the given bounds.
    private static func createClearButton(within bounds: CGRect) -> UIButton {
        let button = UIButton(frame: getClearButtonRect(within: bounds))
        let icon = BerryConstants.deleteIcon
        button.setImage(icon, for: .normal)
        return button
    }

    /// Clears the canvas when the clear button is tapped.
    @objc func clearButtonTap() {
        drawingCanvas.drawing = PKDrawing()
        delegate?.clear(canvas: self)
    }

    private static func getClearButtonRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: BerryConstants.buttonRadius, height: BerryConstants.buttonRadius)
        let origin = CGPoint(
            x: bounds.width - BerryConstants.buttonRadius - BerryConstants.canvasPadding,
            y: BerryConstants.canvasPadding)
        return CGRect(origin: origin, size: size)
    }

    private static func getCanvasRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: bounds.height - BerryConstants.paletteHeight)
        let origin = CGPoint.zero
        return CGRect(origin: origin, size: size)
    }

    private static func getPalatteRect(within bounds: CGRect) -> CGRect {
        let size = CGSize(width: bounds.width, height: BerryConstants.paletteHeight)
        let origin = CGPoint(x: 0, y: bounds.height - BerryConstants.paletteHeight)
        return CGRect(origin: origin, size: size)
    }

    private static func getBackgroundRect(within bounds: CGRect) -> CGRect {
        CGRect(origin: CGPoint.zero, size: bounds.size)
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

    func isWithinDrawableLimit(position: CGPoint) -> Bool {
        guard let area = drawableArea else {
            return true
        }
        return position.x >= area.origin.x
            && position.x <= area.origin.x + area.width
            && position.y >= area.origin.y
            && position.y <= area.origin.y + area.height
    }
}
