//
//  AppViewModel.swift
//  Stan
//
//  Created by Michał Lisicki on 03/01/2025.
//

import Combine
import SwiftUI
import SwiftData

final class StanViewModel: ObservableObject {
    @AppStorage("countOfStans") private(set) var countOfStans: Int = 0
    @AppStorage("isBreakActive") private(set) var isBreakActive: Bool = false
    @AppStorage("numberOfStans") private(set) var numberOfStans: Int = 4
    @AppStorage("stanDuration") private(set) var stanDuration: TimeInterval = 25 * 60
    @AppStorage("shortBreakDuration") private(set) var shortBreakDuration: TimeInterval = 5 * 60
    @AppStorage("longBreakDuration") private(set) var longBreakDuration: TimeInterval = 30 * 60

        
     func startStan() {
        startTimer()
        createStartData()
    }
    
    func pauseStan() {
        stopTimer()
    }
    
    func resetStan() {
        resetTimer()
        isBreakActive = false
        countOfStans = 0
    }
    
    func skip() {
        if isBreakActive {
            endBreak()
        } else {
            resetTimer()
            startBreak()
        }
    }
    
    func startBreak() {
        if let existingStanData = fetchStanDataForToday() {
            updateStanCount(for: existingStanData)
        } else {
            saveNewStanData()
        }
        countOfStans += 1
        
        clearElapsedTime()
        isBreakActive = true
        
    }
    
    func endBreak() {
        clearElapsedTime()
        if countOfStans == numberOfStans {
            countOfStans = 0
        }
        isBreakActive = false
    }
    
    func breakThreshold() -> TimeInterval {
        (countOfStans % numberOfStans) != 0 ? shortBreakDuration : longBreakDuration
    }
    
    private func makeWindowFloat(_ shouldFloat: Bool) {
        Task { @MainActor in
            if let window = NSApplication.shared.windows.first {
                window.level = shouldFloat ? .floating : .normal
            }
        }
    }
    
    
    //MARK: - Timer
    
    @AppStorage("timerElapsed") private(set) var timeElapsed: TimeInterval = 0
    @Published private(set) var isCounting = false
    private var timerCancellable: AnyCancellable?
    
    func startTimer() {
        guard !isCounting else { return }
        isCounting = true
        timerCancellable = Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timeElapsed += 1
            }
        
        makeWindowFloat(true)
    }
    
    func stopTimer() {
        isCounting = false
        timerCancellable?.cancel()
        timerCancellable = nil
        
        makeWindowFloat(false)
    }
    
    func resetTimer() {
        stopTimer()
        clearElapsedTime()
    }
    
    func clearElapsedTime() {
        timeElapsed = 0
    }
    
    private var context: ModelContext
    private var startTime: Date?
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - SwiftData
    
    private func fetchStanDataForToday() -> StanData? {
        let start = Calendar.autoupdatingCurrent.startOfDay(for: .now)
        let end = Calendar.autoupdatingCurrent.date(byAdding: .init(day: 1), to: start) ?? start
        
        let predicate = #Predicate<StanData> { stan in
            stan.day > start && stan.day < end
        }
        
        let descriptor = FetchDescriptor<StanData>(predicate: predicate)
        
        do {
            let results = try context.fetch(descriptor)
            
            guard results.count == 1 else {
                throw DataError.countError
            }
            
            return results.first
        } catch DataError.countError {
            print("More than one today in data present")
        } catch {
            print("Failed to fetch StanData: \(error)")
        }
        return nil
    }
    
    func createStartData() {
        if let stanData = fetchStanDataForToday() {
            stanData.detailedSessions.append(StanDataDetailed(stanStartDate: Date.now))
        }
    }
    
    func updateStanCount(for stanData: StanData) {
        stanData.totalCountOfStans += 1
        saveContext()
    }
    
    func saveNewStanData() {
        let newStanData = StanData(day: .now, totalCountOfStans: 1)
        context.insert(newStanData)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save StanData: \(error)")
        }
    }

}

enum DataError: Error {
    case countError
}
