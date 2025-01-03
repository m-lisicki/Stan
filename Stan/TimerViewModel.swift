//
//  TimerViewModel.swift
//  Stan
//
//  Created by Michał Lisicki on 03/01/2025.
//

import Combine
import Foundation

class TimerViewModel: ObservableObject {
    @Published var timeElapsed: TimeInterval = 0
    @Published var isCounting = false
    private var timerCancellable: AnyCancellable?

    // Start the timer
    func startTimer() {
        guard !isCounting else { return }
        isCounting = true
        timerCancellable = Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timeElapsed += 1
            }
    }

    // Stop the timer
    func stopTimer() {
        isCounting = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    // Resets the timer counter
    func resetTimer() {
        stopTimer()
        timeElapsed = 0
    }
}
