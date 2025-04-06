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
                    Text(appVM.isBreakActive ? "Break" : "Stan" + " \(appVM.countOfStans)/\(appVM.numberOfStans)")
                    Button(action:
                            { openWindow(id: "charts-screen")}) {
                        Image(systemName: "chart.xyaxis.line").fontWeight(.light)
                    }
                }
                .padding(.bottom, 1)
                .buttonStyle(.link)
                HStack {
                    Button("Skip") {
                        appVM.skip()
                    }
                    Button("Reset") {
                        appVM.resetStan()
                    }
                }
                .buttonStyle(.link)
                .padding(.bottom, 1)
                timerView
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding()
        }
        .toolbarBackground(.thickMaterial)
    }
    
    private var timerView: some View {
        VStack {
            Text(ContentView.formattedTime(for: appVM.timeElapsed, threshold: !appVM.isBreakActive ? appVM.stanDuration : appVM.breakThreshold()))
                    .monospacedDigit()
                    .fontDesign(.serif)
                    .font(.largeTitle)
                    .contentTransition(timerTransition ? .numericText(countsDown: true) : .identity)
                    .animation(timerTransition ? .default : nil, value: appVM.timeElapsed)
            
            if !appVM.isBreakActive ? appVM.timeElapsed < appVM.stanDuration : appVM.timeElapsed < appVM.breakThreshold() {
                HStack {
                    Button(appVM.isCounting ? "Pause" : "Start") {
                        if !appVM.isCounting {
                            appVM.startStan()
                        } else {
                            appVM.pauseStan()
                        }
                    }
                    .keyboardShortcut(.space, modifiers: [])
                }
            } else {
                HStack {
                    if !appVM.isBreakActive {
                        Button("Start Break") {
                            appVM.startBreak()
                        }
                        .keyboardShortcut(.space, modifiers: [])
                    } else {
                        Button("Start Stan") {
                            appVM.endBreak()
                        }
                        .keyboardShortcut(.space, modifiers: [])
                    }
                }
            }
        }
    }
    
    static private func formattedTime(for currentTime: TimeInterval, threshold: TimeInterval) -> String {
        let difference = currentTime - threshold
        return difference < 0 ? timeString(-difference) : "+" + timeString(difference)
    }
    
    static private func timeString(_ time: TimeInterval) -> String {
        String(format: "%02d:%02d", Int(time) / 60, Int(time) % 60)
    }
}


#Preview {
    let container = try! ModelContainer(for: StanData.self)
    return ContentView(modelContext: container.mainContext)
}

