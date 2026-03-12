//
//  SharedMetronomeStateTests.swift
//  MetronomeAppTests
//

import XCTest
@testable import MetronomeApp

final class SharedMetronomeStateTests: XCTestCase {

    private var suiteName: String!
    private var testDefaults: UserDefaults!
    private var state: SharedMetronomeState!

    override func setUp() {
        super.setUp()
        suiteName = "test.metronome.\(UUID().uuidString)"
        testDefaults = UserDefaults(suiteName: suiteName)!
        state = SharedMetronomeState(userDefaults: testDefaults)
    }

    override func tearDown() {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    // MARK: - BPM (preference — should persist)

    func testBPMDefaultsTo180() {
        XCTAssertEqual(state.bpm, 180)
    }

    func testBPMPersistsValue() {
        state.bpm = 195
        XCTAssertEqual(state.bpm, 195)
    }

    func testBPMRoundTripsViaUserDefaults() {
        state.bpm = 170
        let value = testDefaults.integer(forKey: "bpm")
        XCTAssertEqual(value, 170, "BPM should be stored in UserDefaults")
    }

    // MARK: - Volume (preference — should persist)

    func testVolumeDefaultsTo04() {
        XCTAssertEqual(state.volume, 0.4, accuracy: 0.001)
    }

    func testVolumePersistsValue() {
        state.volume = 0.8
        XCTAssertEqual(state.volume, 0.8, accuracy: 0.001)
    }

    // MARK: - isPlaying (cross-process state — must be shared)

    func testIsPlayingDefaultsToFalse() {
        XCTAssertFalse(state.isPlaying)
    }

    func testIsPlayingPersistsValue() {
        state.isPlaying = true
        XCTAssertTrue(state.isPlaying)
    }

    func testIsPlayingRoundTripsViaUserDefaults() {
        state.isPlaying = true
        let value = testDefaults.bool(forKey: "isPlaying")
        XCTAssertTrue(value, "isPlaying must be in UserDefaults so widget intents can read it cross-process")
    }

    func testIsPlayingSurvivesCrossProcessRead() {
        // Simulates the widget extension reading isPlaying after the main app set it.
        // This is the fix for the bug where IncrementBPMIntent read isPlaying from
        // Activity.activities (stale, defaults to false) and overwrote the correct state.
        state.isPlaying = true

        // Read directly from UserDefaults (as another process would)
        testDefaults.synchronize()
        XCTAssertTrue(testDefaults.bool(forKey: "isPlaying"),
                      "isPlaying must be readable from another process via shared UserDefaults")
    }
}
