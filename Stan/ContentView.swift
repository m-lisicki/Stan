//
//  ContentView.swift
//  Stan
//
//  Created by Michał Lisicki on 02/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerVM = TimerViewModel()
    @State private var countOfStans = 0
    @State private var isBreakActive = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            VStack {
                Text("Stan's: \(countOfStans % 4)/4")
                if isBreakActive {
                    breakTimerView
                } else {
                    stanTimerView
                }
            }
            .foregroundColor(Color(red: 238/255, green: 238/255, blue: 238/255))
            .padding()
        }
        .toolbarBackground(.thickMaterial)
        .frame(minWidth: 170, minHeight: 130)
    }
    
    private var stanTimerView: some View {
        VStack {
            Text(formattedTime(for: timerVM.timeElapsed, threshold: 25 * 60))
                .timerStyle(timeElapsed: timerVM.timeElapsed)
            
            if timerVM.timeElapsed <= 25 * 60 {
                HStack {
                    Button(timerVM.isCounting ? "Pause" : "Start") {
                        if !timerVM.isCounting {
                            timerVM.startTimer()
                        } else {
                            timerVM.stopTimer()
                        }
                    }
                    .keyboardShortcut(.space, modifiers: [])
                    Button("Reset") {
                        timerVM.resetTimer()
                        countOfStans = 0
                    }
                }
            } else {
                HStack {
                    Button("Start Break") {
                        startBreak()
                    }
                    .keyboardShortcut(.space, modifiers: [])
                }
            }
        }
    }
    
    private var breakTimerView: some View {
        let breakThreshold: TimeInterval = (countOfStans % 4) == 0 && countOfStans != 1 ? 5 * 60 : 30 * 60
        return VStack {
            Text(formattedTime(for: timerVM.timeElapsed, threshold: breakThreshold))
                .timerStyle(timeElapsed: timerVM.timeElapsed)
            
            Button("Start Stan") {
                endBreak()
            }
            .keyboardShortcut(.space, modifiers: [])
        }
    }
    
    private func formattedTime(for currentTime: TimeInterval, threshold: TimeInterval) -> String {
        let difference = currentTime - threshold
        return difference < 0 ? timeString(-difference) : "+" + timeString(difference)
    }
    
    private func timeString(_ time: TimeInterval) -> String {
        String(format: "%02d:%02d", Int(time) / 60, Int(time) % 60)
    }
    
    private func startBreak() {
        countOfStans += 1
        timerVM.timeElapsed = 0
        isBreakActive = true
    }
    
    private func endBreak() {
        timerVM.timeElapsed = 0
        isBreakActive = false
    }
    
    private func updateWindowToFloat(_ value: Bool) {
        if let window = NSApplication.shared.windows.first {
            if value == true {
                window.level = .floating
            } else {
                window.level = .normal
            }
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    func timerStyle(timeElapsed: TimeInterval) -> some View {
        self
            .fontDesign(.serif)
            .font(.largeTitle)
            .contentTransition(.numericText(countsDown: true))
            .animation(.default, value: timeElapsed)
    }
}
