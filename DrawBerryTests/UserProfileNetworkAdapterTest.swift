//
//  UserProfileNetworkAdapterTest.swift
//  DrawBerryTests
//
//  Created by Calvin Chen on 5/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import XCTest
@testable import DrawBerry

class UserProfileNetworkAdapterTest: XCTestCase {

    let testUserID = "testUser"
    let image = #imageLiteral(resourceName: "red")
    let imageData = #imageLiteral(resourceName: "red").pngData()!

    func testUploadDataSuccess() {
        let cloud = UserProfileNetworkAdapter.cloud
        let cloudPathRef = cloud.child("users").child(testUserID).child(Constants.profilePictureFileName)
        UserProfileNetworkAdapter.uploadDataToDatabase(data: imageData, reference: cloudPathRef)

        // Use download to test if upload was successful
        let expectation = self.expectation(description: "Upload")
        let stub = UserProfileNetworkDelegateStub(expectation: expectation)
        UserProfileNetworkAdapter.downloadDataFromDatabase(reference: cloudPathRef, delegate: stub)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(stub.image, "Image does not exist")
        XCTAssertEqual(stub.image?.pngData(),
                       imageData, "Downloaded image is different from uploaded image")
    }

    func testDownloadDataSuccess_withStub() {
        let expectation = self.expectation(description: "Download")
        let stub = UserProfileNetworkDelegateStub(expectation: expectation)
        let cloud = UserProfileNetworkAdapter.cloud
        let cloudPathRef = cloud.child("users").child(testUserID).child(Constants.profilePictureFileName)
        UserProfileNetworkAdapter.downloadDataFromDatabase(reference: cloudPathRef, delegate: stub)
        waitForExpectations(timeout: 5, handler: nil)
    }
}

class UserProfileNetworkDelegateStub: UserProfileNetworkDelegate {
    var expectation: XCTestExpectation
    var image: UIImage?

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func loadImage(image: UIImage?) {
        self.image = image
        expectation.fulfill()
    }
}
