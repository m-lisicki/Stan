//
//  SettingsView.swift
//  Stan
//
//  Created by Michał Lisicki on 04/01/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                GeneralSettingsView()
                    .frame(maxWidth: 350, minHeight: 70)
            }
            Tab("Durations", systemImage: "hourglass") {
                DurationsSettingsView()
                    .frame(maxWidth: 350, minHeight: 100)
            }
        }
        .scenePadding()
    }
}

struct GeneralSettingsView: View {
    @AppStorage("timerTransition") private var timerTransition = false

    var body: some View {
        Form {
            Toggle("Timer Transition Animation", isOn: $timerTransition)
        }
    }
}



struct DurationsSettingsView: View {
    @AppStorage("stanDuration") private var stanDuration: TimeInterval = 25 * 60
    @AppStorage("shortBreakDuration") private var shortBreakDuration: TimeInterval = 5 * 60
    @AppStorage("longBreakDuration") private var longBreakDuration: TimeInterval = 30 * 60
    @AppStorage("numberOfStans") private var numberOfStans: Int = 4
    
    
    var body: some View {
        Form {
            Picker("Number of Stan's:", selection: $numberOfStans) {
                ForEach([1,2,3,4], id: \.self) { value in
                    Text(String(value)).tag(value)
                }
            }
            Picker("Stan Duration:", selection: Binding(
                get: { stanDuration / 60 },
                set: { stanDuration = $0 * 60 }
            )) {
                ForEach([25,50,90], id: \.self) { value in
                    Text("\(value) minutes").tag(TimeInterval(value))
                }
            }
            
            Picker("Short Break Time:", selection: Binding(
                get: { shortBreakDuration / 60 },
                set: { shortBreakDuration = $0 * 60 }
            )) {
                ForEach([5,10], id: \.self) { value in
                    Text("\(value) minutes").tag(TimeInterval(value))
                }
            }
            
            Picker("Long Break Time:", selection: Binding(
                get: { longBreakDuration / 60 },
                set: { longBreakDuration = $0 * 60 }
            )) {
                ForEach([15,30,60], id: \.self) { value in
                    Text("\(value) minutes").tag(TimeInterval(value))
                }
            }
        }
    }
}
