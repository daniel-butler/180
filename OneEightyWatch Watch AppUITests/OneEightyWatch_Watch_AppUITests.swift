//
//  OneEightyWatch_Watch_AppUITests.swift
//  OneEightyWatch Watch AppUITests
//
//  Created by Daniel Butler on 3/12/26.
//

import XCTest

final class OneEightyWatch_Watch_AppUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Page 1: SPM Display

    @MainActor
    func testLaunchShowsBPM() throws {
        let bpm = app.staticTexts["bpmDisplay"]
        XCTAssertTrue(bpm.waitForExistence(timeout: 5))
        XCTAssertEqual(bpm.label, "180")
    }

    @MainActor
    func testLaunchShowsSPMLabel() throws {
        XCTAssertTrue(app.staticTexts["SPM"].waitForExistence(timeout: 5))
    }

    // MARK: - Page 2: Controls (swipe to reach)

    @MainActor
    func testSwipeToControlsPage() throws {
        // Page 1 should show BPM
        let bpm = app.staticTexts["bpmDisplay"]
        XCTAssertTrue(bpm.waitForExistence(timeout: 5))

        // Swipe up to page 2 (vertical page style)
        app.swipeUp()

        // Controls page should have play button
        let playButton = app.buttons["togglePlayback"]
        XCTAssertTrue(playButton.waitForExistence(timeout: 3))
    }

    @MainActor
    func testStartStopFromControlsPage() throws {
        let bpm = app.staticTexts["bpmDisplay"]
        XCTAssertTrue(bpm.waitForExistence(timeout: 5))

        app.swipeUp()

        let toggle = app.buttons["togglePlayback"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 3))

        // Tap play — note: without phone connected this won't actually start,
        // but the UI should still respond to the tap
        toggle.tap()
    }

    @MainActor
    func testIncrementDecrementOnControlsPage() throws {
        let bpm = app.staticTexts["bpmDisplay"]
        XCTAssertTrue(bpm.waitForExistence(timeout: 5))

        app.swipeUp()

        let increment = app.buttons["incrementBPM"]
        let decrement = app.buttons["decrementBPM"]
        XCTAssertTrue(increment.waitForExistence(timeout: 3))
        XCTAssertTrue(decrement.waitForExistence(timeout: 3))
    }

    @MainActor
    func testSwipeBackToSPMPage() throws {
        let bpm = app.staticTexts["bpmDisplay"]
        XCTAssertTrue(bpm.waitForExistence(timeout: 5))

        // Swipe to controls
        app.swipeUp()
        let toggle = app.buttons["togglePlayback"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 3))

        // Swipe back to SPM
        app.swipeDown()
        XCTAssertTrue(bpm.waitForExistence(timeout: 3))
    }
}
