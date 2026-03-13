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

    // MARK: - Launch State

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

    @MainActor
    func testControlButtonsExist() throws {
        XCTAssertTrue(app.buttons["togglePlayback"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["incrementBPM"].exists)
        XCTAssertTrue(app.buttons["decrementBPM"].exists)
    }
}
