//
//  SharedMetronomeState.swift
//  MetronomeApp
//
//  Created by Claude on 12/23/25.
//

import Foundation
import os
#if canImport(WidgetKit)
import WidgetKit
#endif

private let logger = Logger(subsystem: "com.danielbutler.MetronomeApp", category: "SharedState")

// Darwin notification names for cross-process communication
enum MetronomeNotification {
    static let stateChanged = "com.danielbutler.MetronomeApp.stateChanged"
    static let commandStart = "com.danielbutler.MetronomeApp.command.start"
    static let commandStop = "com.danielbutler.MetronomeApp.command.stop"
}

final class SharedMetronomeState: Sendable {
    static let shared = SharedMetronomeState()

    private let appGroupID = "group.com.danielbutler.MetronomeApp"
    nonisolated(unsafe) private let userDefaults: UserDefaults?

    private init() {
        userDefaults = UserDefaults(suiteName: appGroupID)
    }

    /// Test-only initializer for dependency injection
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    // MARK: - BPM

    /// Force-read latest values from disk (call before reading in cross-process scenarios)
    nonisolated func synchronize() {
        userDefaults?.synchronize()
    }

    nonisolated var bpm: Int {
        get {
            let value = userDefaults?.integer(forKey: "bpm") ?? 0
            let result = value == 0 ? 180 : value
            logger.debug("SharedState.bpm GET → \(result)")
            return result
        }
        set {
            logger.info("SharedState.bpm SET \(newValue)")
            userDefaults?.set(newValue, forKey: "bpm")
            userDefaults?.synchronize()
            postStateChangeNotification()
        }
    }

    // MARK: - isPlaying

    nonisolated var isPlaying: Bool {
        get {
            userDefaults?.bool(forKey: "isPlaying") ?? false
        }
        set {
            logger.info("SharedState.isPlaying SET \(newValue)")
            userDefaults?.set(newValue, forKey: "isPlaying")
            userDefaults?.synchronize()
        }
    }

    // MARK: - Volume

    nonisolated var volume: Float {
        get {
            let value = userDefaults?.float(forKey: "volume") ?? 0.0
            return value == 0 ? 0.4 : value
        }
        set {
            userDefaults?.set(newValue, forKey: "volume")
            userDefaults?.synchronize()
        }
    }

    // MARK: - Widget Refresh

    @MainActor
    func notifyWidgetUpdate() {
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }

    // MARK: - Cross-Process Notifications

    private func postStateChangeNotification() {
        logger.info("Posting Darwin notification: stateChanged")
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            CFNotificationName(MetronomeNotification.stateChanged as CFString),
            nil, nil, true
        )
    }

    /// Post a play or stop command notification (no UserDefaults involved)
    nonisolated static func postCommand(_ command: String) {
        logger.info("Posting Darwin command: \(command)")
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            CFNotificationName(command as CFString),
            nil, nil, true
        )
    }
}
