//
//  DrawBerryUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import FBSnapshotTestCase

class DrawBerryUITest: FBSnapshotTestCase {
    internal func verifyAppCurrentScreen(app: XCUIApplication) {
        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView)
    }

    internal func verifyAppCurrentScreen(app: XCUIApplication, tolerance: CGFloat) {
        guard let imageView = UIImageView(image: app.screenshot().image).withoutStatusBar else {
            XCTFail("Unable to remove status bar")
            return
        }
        FBSnapshotVerifyView(imageView, identifier: nil, perPixelTolerance: tolerance, overallTolerance: tolerance)
    }
}
