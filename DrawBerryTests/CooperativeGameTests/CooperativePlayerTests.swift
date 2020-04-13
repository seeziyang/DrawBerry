//
//  CooperativePlayerTests.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 30/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class CooperativePlayerTests: XCTestCase {
    var cooperativePlayer = CooperativePlayer(name: "bob", uid: "q1w2e3", isRoomMaster: false)

    override func setUp() {
        super.setUp()
        cooperativePlayer = CooperativePlayer(name: "bob", uid: "q1w2e3", isRoomMaster: false)
    }

    func testConstruct() {
        let cooperativePlayer = CooperativePlayer(name: "bob", uid: "q1w2e3", isRoomMaster: false)

        XCTAssertEqual(cooperativePlayer.name, "bob", "CooperativePlayer's name is not constructed properly")
        XCTAssertEqual(cooperativePlayer.uid, "q1w2e3", "CooperativePlayer's uid is not constructed properly")
        XCTAssertFalse(cooperativePlayer.isRoomMaster, "CooperativePlayer's isRoomMaster is not constructed properly")
    }

    func testConstruct_fromRoomPlayer() {
        let cooperativePlayer = CooperativePlayer(
            from: RoomPlayer(name: "bobby", uid: "987oiu", isRoomMaster: true))

        XCTAssertEqual(cooperativePlayer.name, "bobby", "CooperativePlayer's name is not constructed properly")
        XCTAssertEqual(cooperativePlayer.uid, "987oiu", "CooperativePlayer's uid is not constructed properly")
        XCTAssertTrue(cooperativePlayer.isRoomMaster, "CooperativePlayer's isRoomMaster is not constructed properly")
    }

    func testAddDrawingAndGetDrawingImage() {
        cooperativePlayer.addDrawing(image: UIImage())
        let round1Image = cooperativePlayer.getDrawingImage()

        XCTAssertEqual(round1Image, UIImage(), "CooperativePlayer's addDrawing or getDrawingImage is not correct")
        XCTAssertNotNil(round1Image, "CooperativePlayer's addDrawing or getDrawingImage is not correct")
    }

    func testCompare() {
        let largerCooperativePlayer = CooperativePlayer(name: "alice", uid: "r1w2e3", isRoomMaster: false)
        let smallerCooperativePlayer = CooperativePlayer(name: "charles", uid: "p1w2e3", isRoomMaster: false)
        let sameUIDDifferentDetails = CooperativePlayer(name: "bobo", uid: "q1w2e3", isRoomMaster: false)
        XCTAssertTrue(cooperativePlayer < largerCooperativePlayer)
        XCTAssertTrue(smallerCooperativePlayer < cooperativePlayer)
        XCTAssertTrue(smallerCooperativePlayer < largerCooperativePlayer)
        XCTAssertEqual(cooperativePlayer, sameUIDDifferentDetails)
    }
}
