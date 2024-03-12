//
//  StopApp.swift
//  Stop
//
//  Created by Hoon on 3/4/24.
//

import SwiftUI

@main
struct StopApp: App {
    // MARK: Since We're doing Backgound fetching Initalizing Here
    @State var pomodoroModel: PomodoroModel = .init()
    // MARK: Scene Phase
    @Environment(\.scenePhase) var phase
    // MARK: Storing Last Time Stamp
    @State var lastActiveTimeStamp: Date = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroModel)
        }
        .onChange(of: phase, initial: true) { _, newValue in
            if pomodoroModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }

                if newValue == .active {
                    // MARK: Finding The Difference
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                    } else {
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
