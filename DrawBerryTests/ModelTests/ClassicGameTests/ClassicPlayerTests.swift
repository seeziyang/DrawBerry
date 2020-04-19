//
//  ClassicPlayerTests.swift
//  DrawBerryTests
//
//  Created by See Zi Yang on 21/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class ClassicPlayerTests: XCTestCase {
    var classicPlayer = ClassicPlayer(name: "bob", uid: "q1w2e3", isRoomMaster: false)

    override func setUp() {
        super.setUp()
        classicPlayer = ClassicPlayer(name: "bob", uid: "q1w2e3", isRoomMaster: false)
    }

    func testConstruct() {
        let classicPlayer = ClassicPlayer(name: "bob", uid: "q1w2e3", isRoomMaster: false)

        XCTAssertEqual(classicPlayer.name, "bob", "ClassicPlayer's name is not constructed properly")
        XCTAssertEqual(classicPlayer.uid, "q1w2e3", "ClassicPlayer's uid is not constructed properly")
        XCTAssertFalse(classicPlayer.isRoomMaster, "ClassicPlayer's isRoomMaster is not constructed properly")
        XCTAssertEqual(classicPlayer.points, 0, "ClassicPlayer's points is not constructed properly")
    }

    func testConstruct_fromRoomPlayer() {
        let classicPlayer = ClassicPlayer(from: RoomPlayer(name: "bobby", uid: "987oiu", isRoomMaster: true))

        XCTAssertEqual(classicPlayer.name, "bobby", "ClassicPlayer's name is not constructed properly")
        XCTAssertEqual(classicPlayer.uid, "987oiu", "ClassicPlayer's uid is not constructed properly")
        XCTAssertTrue(classicPlayer.isRoomMaster, "ClassicPlayer's isRoomMaster is not constructed properly")
        XCTAssertEqual(classicPlayer.points, 0, "ClassicPlayer's points is not constructed properly")
    }

    func testAddDrawingAndGetDrawingImage() {
        classicPlayer.addDrawing(image: UIImage())
        classicPlayer.addDrawing(image: UIImage())
        let round1Image = classicPlayer.getDrawingImage(ofRound: 1)
        let round2Image = classicPlayer.getDrawingImage(ofRound: 2)

        XCTAssertEqual(round1Image, UIImage(), "ClassicPlayer's addDrawing or getDrawingImage is not correct")
        XCTAssertNotNil(round1Image, "ClassicPlayer's addDrawing or getDrawingImage is not correct")
        XCTAssertEqual(round2Image, UIImage(), "ClassicPlayer's addDrawing or getDrawingImage is not correct")
        XCTAssertNotNil(round2Image, "ClassicPlayer's addDrawing or getDrawingImage is not correct")
    }

    func testGetDrawingImage_invalidRound_returnsNil() {
        classicPlayer.addDrawing(image: UIImage())
        classicPlayer.addDrawing(image: UIImage())

        XCTAssertNil(classicPlayer.getDrawingImage(ofRound: 0),
                     "ClassicPlayer's addDrawing or getDrawingImage is not correct")
        XCTAssertNil(classicPlayer.getDrawingImage(ofRound: -1),
                     "ClassicPlayer's addDrawing or getDrawingImage is not correct")
        XCTAssertNil(classicPlayer.getDrawingImage(ofRound: 3),
                     "ClassicPlayer's addDrawing or getDrawingImage is not correct")
        XCTAssertNil(classicPlayer.getDrawingImage(ofRound: 99),
                     "ClassicPlayer's addDrawing or getDrawingImage is not correct")
    }

    func testVoting() {
        let votedForPlayer = ClassicPlayer(name: "amy", uid: "amybk", isRoomMaster: false)
        classicPlayer.voteFor(player: votedForPlayer)

        XCTAssertTrue(classicPlayer.hasVoted(inRound: 1), "ClassicPlayer's voting is not correct")
        XCTAssertEqual(classicPlayer.getVotedPlayer(inRound: 1), votedForPlayer,
                       "ClassicPlayer's voting is not correct")
    }
}
