//
//  ContentView.swift
//  Stan
//
//  Created by Michał Lisicki on 02/01/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var appVM: StanViewModel
    
    init(modelContext: ModelContext) {
        let appVM = StanViewModel(context: modelContext)
        _appVM = StateObject(wrappedValue: appVM)
    }
    
    @AppStorage("timerTransition") private var timerTransition = false
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        ZStack {
            GradientBackground().ignoresSafeArea()
            VStack {
                HStack {
                    Text("Stan's: \(appVM.countOfStans)/\(appVM.numberOfStans)")
                    Button(action:
                            { openWindow(id: "charts-screen")}) {
                        Image(systemName: "chart.xyaxis.line").fontWeight(.light)
                    }.buttonStyle(.plain)
                }
                .padding(.bottom, 1)
                if appVM.isBreakActive {
                    breakTimerView
                } else {
                    stanTimerView
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding()
        }
        .toolbarBackground(.thickMaterial)
    }
    
    private var stanTimerView: some View {
        VStack {
            Text(formattedTime(for: appVM.timeElapsed, threshold: appVM.stanDuration))
                .timerStyle(timeElapsed: appVM.timeElapsed, isOn: timerTransition)
            
            if appVM.timeElapsed < appVM.stanDuration {
                HStack {
                    Button(appVM.isCounting ? "Pause" : "Start") {
                        if !appVM.isCounting {
                            appVM.startStan()
                        } else {
                            appVM.pauseStan()
                        }
                    }
                    .keyboardShortcut(.space, modifiers: [])
                    Button("Reset") {
                        appVM.resetStan()
                    }
                }
            } else {
                HStack {
                    Button("Start Break") {
                        appVM.startBreak()
                    }
                    .keyboardShortcut(.space, modifiers: [])
                }
            }
        }
    }
    
    private var breakTimerView: some View {
        VStack {
            Text(formattedTime(for: appVM.timeElapsed, threshold: appVM.breakThreshold()))
                .timerStyle(timeElapsed: appVM.timeElapsed, isOn: timerTransition)
            HStack {
                Button(appVM.isCounting ? "Pause" : "Start") {
                    if !appVM.isCounting {
                        appVM.startStan()
                    } else {
                        appVM.pauseStan()
                    }
                }
                .keyboardShortcut(.space, modifiers: [])
                Button("Start Stan") {
                    appVM.endBreak()
                }
            }
        }
    }
    
    private func formattedTime(for currentTime: TimeInterval, threshold: TimeInterval) -> String {
        let difference = currentTime - threshold
        return difference < 0 ? timeString(-difference) : "+" + timeString(difference)
    }
    
    private func timeString(_ time: TimeInterval) -> String {
        String(format: "%02d:%02d", Int(time) / 60, Int(time) % 60)
    }
}

extension View {
    func timerStyle(timeElapsed: TimeInterval, isOn: Bool) -> some View {
        return self
            .fontDesign(.serif)
            .font(.largeTitle)
            .contentTransition(isOn ? .numericText(countsDown: true) : .identity)
            .animation(isOn ? .default : nil, value: timeElapsed)
    }
}


#Preview {
    let container = try! ModelContainer(for: StanData.self)
    return ContentView(modelContext: container.mainContext)
}

