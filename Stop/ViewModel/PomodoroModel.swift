//
//  PomodoroModel.swift
//  Stop
//
//  Created by Hoon on 3/4/24.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // MARK: Timer Properties
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false

    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0

    // MARK: TotalSeconds
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0

    // MARK: Post Timer Properties
    @Published var isFinished: Bool = false

    override init() {
        super.init()
        authorizeNotification()
    }

    // MARK: Requesting Notification Access
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in }

        // MARK: To Shwo In App Notification
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }

    // MARK: Starting Timer
    func startingTimer() {
        withAnimation(.easeInOut(duration: 0.25)) { isStarted = true }
        // MARK: Setting Starting Time Value
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        // MARK: Calculating Total Seconds For Timer Animation
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }

    // MARK: Stopping Timer
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }

    // MARK: Updating Timer
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"

        if hour == 0 && seconds == 0 && minutes == 0 {
            isStarted = false
            isFinished = true
            print("Finished")
        }
    }

    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.subtitle = "Congratulations You did it hooray!!"
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval:
                TimeInterval(staticTotalSeconds),
                repeats: false
            )
        )

        UNUserNotificationCenter.current().add(request)
    }
}
