import ActivityKit

struct MetronomeActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var bpm: Int
        var isPlaying: Bool
    }
}
