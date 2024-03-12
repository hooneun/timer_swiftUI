//
//  ContentView.swift
//  Stop
//
//  Created by Hoon on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel

    var body: some View {
        Home()
            .environmentObject(pomodoroModel)
    }
}

#Preview {
    ContentView()
}
