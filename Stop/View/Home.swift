//
//  Home.swift
//  Stop
//
//  Created by Hoon on 3/4/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        VStack {
            Text("Pomodoro Timer")
                .font(.title2.bold())
                .foregroundStyle(.white)

            TimerView()
        }
        .padding()
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack {
                Color.black
                    .opacity(pomodoroModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        pomodoroModel.hour = 0
                        pomodoroModel.minutes = 0
                        pomodoroModel.seconds = 0
                        pomodoroModel.addNewTimer = false
                    }

                TimerSettingBottomView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: pomodoroModel.addNewTimer ? 0 : 400)
            }
            .animation(.easeInOut, value: pomodoroModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if pomodoroModel.isStarted {
                pomodoroModel.updateTimer()
            }
        }
        .alert("Congratulations You did it hooray!!", isPresented: $pomodoroModel.isFinished) {
            Button("Start New", role: .cancel) {
                pomodoroModel.startingTimer()
                pomodoroModel.addNewTimer = true
            }
            Button("Close", role: .destructive) {
                pomodoroModel.stopTimer()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PomodoroModel())
}
