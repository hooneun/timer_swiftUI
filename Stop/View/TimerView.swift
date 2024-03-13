//
//  Timer.swift
//  Stop
//
//  Created by Hoon on 3/13/24.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 15) {
                // MARK: Timer Ring
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.03))
                        .padding(-40)

                    Circle()
                        .trim(from: 0, to: pomodoroModel.progress)
                        .stroke(.white.opacity(0.03), lineWidth: 80)
                        .fill(.white.opacity(0.03))

                    // MARK: Shadow
                    Circle()
                        .stroke(Color("Purple"), lineWidth: 5)
                        .blur(radius: 15)
                        .padding(-2)

                    Circle()
                        .fill(Color("BG"))

                    Circle()
                        .trim(from: 0, to: pomodoroModel.progress)
                        .stroke(Color("Purple").opacity(0.7), lineWidth: 10)

                    // MARK: Knob
                    GeometryReader { proxy in
                        let size = proxy.size

                        Circle()
                            .fill(Color("Purple"))
                            .frame(width: 30, height: 30)
                            .overlay(content: {
                                Circle()
                                    .fill(.white)
                                    .padding(5)
                            })
                            .frame(width: size.width, height: size.height, alignment: .center)
                            // MARK: Since View is Rotated Thats Why Using X
                            .offset(x: size.height / 2)
                            .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                    }

                    Text(pomodoroModel.timerStringValue)
                        .font(.system(size: 45, weight: .light))
                        .rotationEffect(.init(degrees: 90))
                        .animation(.none, value: pomodoroModel.progress)
                }
                .padding(60)
                .frame(height: proxy.size.width)
                .rotationEffect(.init(degrees: -90))
                .animation(.easeInOut, value: pomodoroModel.progress)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                Button {
                    if pomodoroModel.isStarted {
                        pomodoroModel.stopTimer()
                        // MARK: Cancelling All Notifications
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    } else {
                        pomodoroModel.addNewTimer = true
                    }
                } label: {
                    Image(systemName: !pomodoroModel.isStarted ? "timer" : "stop.fill")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background {
                            Circle()
                                .fill(Color("Purple"))
                        }
                        .shadow(color: Color("Purple"), radius: 8, x: 0, y: 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    TimerView()
        .environmentObject(PomodoroModel())
}
