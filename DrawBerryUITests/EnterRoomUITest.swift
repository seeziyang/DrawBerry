//
//  EnterRoomUITest.swift
//  DrawBerryUITests
//
//  Created by Hol Yin Ho on 12/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import FBSnapshotTestCase
@testable import DrawBerry

class EnterRoomUITest: DrawBerryUITest {
    let roomTypeToName = [
        GameRoomType.ClassicRoom: "Classic",
        GameRoomType.CooperativeRoom: "Cooperative",
        GameRoomType.TeamBattleRoom: "Team Battle"
    ]

    internal func initialiseAppToEnterRoomScreen(type: GameRoomType) -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        if isLoginPage(app: app) {
            attemptLogin(app: app)
        }
        app.buttons[roomTypeToName[type] ?? "Classic"].tap()
        sleep(1)
        return app
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

    private func attemptLogin(app: XCUIElement) {
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
        emailTextField.typeText("admin1@drawberry.com")

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password1")

        app.buttons["login"].tap()
    }

    private func isLoginPage(app: XCUIElement) -> Bool {
        app.buttons["Login"].exists
    }
}
