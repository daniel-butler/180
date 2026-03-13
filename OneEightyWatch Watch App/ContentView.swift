//
//  ContentView.swift
//  OneEightyWatch Watch App
//
//  Created by Daniel Butler on 3/12/26.
//

import SwiftUI

struct ContentView: View {
    @State private var session = WatchSessionManager()

    var body: some View {
        TabView {
            // Page 1: SPM display — glanceable while running
            VStack(spacing: 8) {
                Text("\(session.bpm)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
                    .accessibilityIdentifier("bpmDisplay")
                Text("SPM")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if session.isPlaying {
                    Image(systemName: "waveform")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .padding(.top, 4)
                }

                if !session.isReachable {
                    Text("Phone not connected")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .padding(.top, 4)
                }
            }

            // Page 2: Controls
            VStack(spacing: 16) {
                // Play/Stop
                Button {
                    session.toggle()
                } label: {
                    Image(systemName: session.isPlaying ? "stop.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(session.isPlaying ? .red : .green)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(.white.opacity(0.2)))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("togglePlayback")

                // Plus / Minus
                HStack(spacing: 24) {
                    Button {
                        session.decrementBPM()
                    } label: {
                        Image(systemName: "minus")
                            .font(.title3)
                            .frame(width: 52, height: 52)
                            .background(Circle().fill(.white.opacity(0.15)))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("decrementBPM")

                    Text("\(session.bpm)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())

                    Button {
                        session.incrementBPM()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .frame(width: 52, height: 52)
                            .background(Circle().fill(.white.opacity(0.15)))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("incrementBPM")
                }
            }
        }
        .tabViewStyle(.verticalPage)
        .onAppear {
            session.activate()
        }
    }
}

#Preview {
    ContentView()
}
