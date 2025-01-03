//
//  StanApp.swift
//  Stan
//
//  Created by Michał Lisicki on 02/01/2025.
//

import SwiftUI
import SwiftData

@main
struct StanApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: StanData.self, StanDataDetailed.self)
        } catch {
            fatalError("Failed to create ModelContainer for StanData.")
        }
    }

    var body: some Scene {
        Window("Stan", id: "main-screen") {
            ContentView(modelContext: container.mainContext)
                .frame(minWidth: 170, minHeight: 130)
        }
        .windowResizability(.contentSize)
        Window("Charts", id: "charts-screen") {
           ChartView()
                .modelContext(container.mainContext)
        }
        .windowResizability(.contentSize)
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
