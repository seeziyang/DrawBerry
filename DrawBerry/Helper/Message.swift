//
//  Message.swift
//  DrawBerry
//
//  Created by Calvin Chen on 12/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

enum Message {
    static let emptyTextField = "Text fields should not be empty!"
    static let whitespaceOnlyTextField = "Text field should not contain whitespaces only!"

    // Login and Sign-up
    static let signInError = "Wrong password or user account does not exists"
    static let signUpError = "Unable to register user!"
    static let invalidEmail = "Email address is invalid. \n Format: abc@example.com"
    static let invalidPassword = """
    Password should be alpha-numerical without special characters,
    with at least 8 characters, containing an alphabet and a number.
    """
    static let passwordsDoNotMatch = "Passwords do not match!"
    static let usernameLengthTooLong = "Length of username should not be greater than 10 characters"

    static let teamBattleWaitingMessage = "Drawer is still drawing~"

    // Classic Room
    static let roomDoesNotExist = "Unable to join as room does not exist"
    static let roomFull = "Unable to join as room is full"
    static let roomCodeTaken = "Room Code already taken, please use another one!"
    static let roomStarted = "Room has already started on its game!"

    // Cooperative Mode
    static let getReadyMessage = "You're up! Get Ready!"
    static let waitingMessage = "Stare at your friend."

    // Competitive Mode
    static let extraStrokePowerup = "Extra Stroke!"
    static let hiddenDrawingPowerup = "Hidden Drawing!"
    static let inkSplotchPowerup = "Ink Splotch!"
    static let invulnerabilityPowerup = "Invulnerable for 5s!"
    static let earthquakePowerup = "Earthquake!"

    static let playerIsInvulnerable = "You're invulnerable!"

    static let competitiveVotingTime = "Voting time!\n\nVote for who you think drew the best two drawings."
    static let competitiveVotingResult = "Here are the voting results!"
    static let competitiveVotingFinalResults = "Final Results:\n\n"
    static let competitiveVotingCurrentResults = "Current Scoreboard:\n\n"

    static let competitiveVotingUsedAllVotes = "You have already used all your votes!"
    static let competitiveVotingCannotSelfVote = "You cannot vote for yourself!"
    static let competitiveVotingAlreadyVoted = "You have already voted for this player!"
}
