//
//  CooperativeGameTests.swift
//  DrawBerryTests
//
//  Created by Hol Yin Ho on 16/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
import Firebase
@testable import DrawBerry

class CooperativeGameTests: XCTestCase {
    var cooperativeGame: CooperativeGame!
    static let testRoomCode = RoomCode(value: "testroom", type: .CooperativeRoom)
    static let roomNetwork = RoomNetworkStub(roomCode: testRoomCode)

    override func setUp() {
        super.setUp()
        let gameRoom =
            GameRoomStub(roomCode: CooperativeGameTests.testRoomCode,
                         roomNetwork: CooperativeGameTests.roomNetwork)
        cooperativeGame = CooperativeGame(from: gameRoom)
        let gameNetworkStub = GameNetworkStub(roomCode: CooperativeGameTests.testRoomCode)
        cooperativeGame.setGameNetwork(to: gameNetworkStub)
    }

    func testConstructor() {
        let gameRoom =
            GameRoomStub(roomCode: CooperativeGameTests.testRoomCode,
                         roomNetwork: CooperativeGameTests.roomNetwork)
        XCTAssertEqual(cooperativeGame.players.map { $0.uid }, gameRoom.players.map { $0.uid })
        XCTAssertTrue(cooperativeGame.allDrawings.isEmpty)
    }

    func testDownloadPreviousDrawings() {
        guard let userIndex = cooperativeGame.getIndex(of: cooperativeGame.user) else {
            XCTFail("User should have index")
            return
        }
        let previousPlayers = cooperativeGame.players.filter {
            cooperativeGame.getIndex(of: $0) ?? 0 < userIndex
        }
        setExpectation(description: "download", fulfillCountRequired: previousPlayers.count)
        cooperativeGame.downloadPreviousDrawings()
        waitForExpectations(timeout: 5, handler: nil)
        let expectedDrawings = Array(repeating: UIImage(), count: previousPlayers.count)
        XCTAssertEqual(expectedDrawings, cooperativeGame.allDrawings)
    }

    func testDownloadSubsequentDrawings() {
        guard let userIndex = cooperativeGame.getIndex(of: cooperativeGame.user) else {
            XCTFail("User should have index")
            return
        }
        let subsequentPlayers = cooperativeGame.players.filter {
            cooperativeGame.getIndex(of: $0) ?? 0 >= userIndex
        }
        setExpectation(description: "download", fulfillCountRequired: subsequentPlayers.count)
        cooperativeGame.downloadSubsequentDrawings()
        waitForExpectations(timeout: 5, handler: nil)
        let expectedDrawings = Array(repeating: UIImage(), count: subsequentPlayers.count)
        XCTAssertEqual(expectedDrawings, cooperativeGame.allDrawings)
    }

    func testAddUserDrawing() {
        let toBeUploaded = UIImage()
        setExpectation(description: "upload", fulfillCountRequired: 1)
        cooperativeGame.addUsersDrawing(image: toBeUploaded)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(cooperativeGame.user.getDrawingImage)
        XCTAssertEqual(cooperativeGame.user.getDrawingImage() ?? UIImage(), toBeUploaded)
    }

    func testGetIndex() {
        let admin1 = cooperativeGame.players.filter { $0.name == "admin1" }[0]
        let admin2 = cooperativeGame.players.filter { $0.name == "admin2" }[0]
        let admin3 = cooperativeGame.players.filter { $0.name == "admin3" }[0]
        var players = [admin1, admin2, admin3]
        players.sort()
        guard let admin1Index = cooperativeGame.getIndex(of: admin1),
            let admin2Index = cooperativeGame.getIndex(of: admin2),
            let admin3Index = cooperativeGame.getIndex(of: admin3) else {
                XCTFail("Should get index of admin1, admin2, admin3")
                return
        }
        XCTAssertEqual(players[admin1Index], admin1)
        XCTAssertEqual(players[admin2Index], admin2)
        XCTAssertEqual(players[admin3Index], admin3)
    }

    func testSetNetwork() {
        let gameNetworkStub1 = GameNetworkStub(roomCode: CooperativeGameTests.testRoomCode)
        let gameNetworkStub2 = GameNetworkStub(roomCode: RoomCode(value: "secondRoomCode", type: .CooperativeRoom))
        let firebaseGameNetwork = FirebaseGameNetworkAdapter(roomCode: CooperativeGameTests.testRoomCode)
        XCTAssertNotEqual(gameNetworkStub1.roomCode, gameNetworkStub2.roomCode)

        cooperativeGame.setGameNetwork(to: gameNetworkStub1)
        XCTAssertEqual(gameNetworkStub1.roomCode, cooperativeGame.roomCode)

        // Game network with different roomcode from game will not be allowed to be set
        cooperativeGame.setGameNetwork(to: gameNetworkStub2)
        XCTAssertEqual(gameNetworkStub1.roomCode, cooperativeGame.roomCode)
        XCTAssertNotEqual(gameNetworkStub2.roomCode, cooperativeGame.roomCode)

        cooperativeGame.setGameNetwork(to: firebaseGameNetwork)
        XCTAssertEqual(firebaseGameNetwork.roomCode, cooperativeGame.roomCode)
    }

    func testEndGame() {
        setExpectation(description: "Game end", fulfillCountRequired: 1)
        cooperativeGame.endGame()
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension CooperativeGameTests {
    func setExpectation(description: String, fulfillCountRequired: Int) {
        let downloadExpectation = self.expectation(description: "download")
        downloadExpectation.expectedFulfillmentCount = fulfillCountRequired
        let gameNetworkStub = GameNetworkStub(roomCode: CooperativeGameTests.testRoomCode)
        gameNetworkStub.setExpectation(expectation: downloadExpectation)
        cooperativeGame.setGameNetwork(to: gameNetworkStub)
    }
}
