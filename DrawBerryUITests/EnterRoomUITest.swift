//
//  EnterRoomUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
import Firebase
@testable import DrawBerry

class EnterRoomUITest: DrawBerryUITest {
    static let defaultTestUser = UITestConstants.admin1_user

    let roomTypeToName = [
        GameRoomType.ClassicRoom: "Classic",
        GameRoomType.CooperativeRoom: "Cooperative",
        GameRoomType.TeamBattleRoom: "Team Battle"
    ]

    internal func initialiseAppToEnterRoomScreen(type: GameRoomType, as user: User) -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isMenuPage(app: app) {
            attemptLogout(app: app)
        }
        attemptLogin(app: app, as: user)
        app.buttons[roomTypeToName[type] ?? "Classic"].tap()
        sleep(1)
        return app
    }

    internal func initialiseAppToEnterRoomScreen(type: GameRoomType) -> XCUIApplication {
        return initialiseAppToEnterRoomScreen(type: type, as: EnterRoomUITest.defaultTestUser)
    }

    internal func joinRoom(app: XCUIApplication, roomCode: RoomCode) {
        let roomCodeTextField = app.textFields["Room Code"]
        roomCodeTextField.tap()
        roomCodeTextField.typeText(roomCode.value)
        app.buttons["Join"].tap()
    }

    internal func createRoom(app: XCUIApplication, roomCode: RoomCode) {
        let roomCodeTextField = app.textFields["Room Code"]
        roomCodeTextField.tap()
        roomCodeTextField.typeText(roomCode.value)
        app.buttons["Create"].tap()
    }

    internal func startGame(app: XCUIApplication, roomCode: RoomCode) {
        app.navigationBars[roomCode.value].buttons["Start"].tap()
        sleep(5)
    }

    private func joinRoom(userID: String, username: String, roomCode: RoomCode) {
        let db = Database.database().reference()
        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .child("players")
            .child(userID)
            .setValue(["username": username,
                       "isRoomMaster": false])
    }

    private func attemptLogin(app: XCUIElement, as user: User) {
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["password"]

        emailTextField.tap()
        emailTextField.clearText()
        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()
        emailTextField.tap()
        emailTextField.clearText()
        passwordSecureTextField.tap()
        passwordSecureTextField.clearText()

        emailTextField.tap()
        emailTextField.typeText(user.email)

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(user.password)

        app.buttons["login"].tap()
    }

    private func isLoginPage(app: XCUIElement) -> Bool {
        app.buttons["Login"].exists
    }

    internal func add(player: User, to roomCode: RoomCode) {
        joinRoom(userID: player.uid, username: player.name, roomCode: roomCode)
        sleep(3)
    }

    private func isMenuPage(app: XCUIApplication) -> Bool {
        app.buttons["Classic"].exists
    }

    private func attemptLogout(app: XCUIApplication) {
        app.buttons["Log out"].tap()
    }

    internal func createRoomProgramatically(roomMaster: User, roomCode: RoomCode) {
        let db = Database.database().reference()
        let userID = roomMaster.uid
        let username = roomMaster.name

        db.child("activeRooms")
            .child(roomCode.type.rawValue)
            .child(roomCode.value)
            .setValue([
                "isRapid": true,
                "players": [
                    userID: [
                        "username": username,
                        "isRoomMaster": true
                    ]
                ]
            ])
    }
}
