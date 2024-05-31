//
//  Slide_Image_With_Left_Swipe_and_Right_SwipeUITestsLaunchTests.swift
//  Slide Image With Left Swipe and Right SwipeUITests
//
//  Created by Anil Kumar Potlapally on 31/05/24.
//

import XCTest

final class Slide_Image_With_Left_Swipe_and_Right_SwipeUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
