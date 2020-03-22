//
//  BerryPaletteTest.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 22/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
/// Most functionality of the palette should be tested with the Canvas object, that is, integration testing
/// in BerryCanvasTest.swift.

import XCTest
import PencilKit
@testable import DrawBerry

class BerryPaletteTest: XCTestCase {
    var palette: BerryPalette!

    override func setUp() {
        super.setUp()
        palette = BerryPalette(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 500, height: 500)))
    }

    func testAddColorAddStrokeContainsTool() {
        palette.add(color: BerryConstants.berryBlack)
        palette.add(stroke: Stroke.thick)

        XCTAssertTrue(palette.contains(tool: PKInkingTool(
            PKInkingTool.InkType.pen,
            color: BerryConstants.berryBlack,
            width: Stroke.thick.rawValue
        )))

        XCTAssertFalse(palette.contains(tool: PKInkingTool(
            PKInkingTool.InkType.pen,
            color: BerryConstants.berryBlack,
            width: Stroke.thin.rawValue
        )))

        XCTAssertFalse(palette.contains(tool: PKInkingTool(
            PKInkingTool.InkType.pen,
            color: BerryConstants.berryRed,
            width: Stroke.thick.rawValue
        )))

        XCTAssertFalse(palette.contains(tool: PKInkingTool(
            PKInkingTool.InkType.pen,
            color: BerryConstants.berryBlue,
            width: Stroke.medium.rawValue
        )))
        palette.add(stroke: Stroke.thin)
        XCTAssertTrue(palette.contains(tool: PKInkingTool(
            PKInkingTool.InkType.pen,
            color: BerryConstants.berryBlack,
            width: Stroke.thin.rawValue
        )))
    }
}
