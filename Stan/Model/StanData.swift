//
//  StanData.swift
//  Stan
//
//  Created by Michał Lisicki on 03/01/2025.
//

import Foundation
import SwiftData

@Model
class StanData: Identifiable {
    var id = UUID()
    var day: Date
    var totalCountOfStans: Int
    var detailedSessions: [StanDataDetailed] = []
    
    init(day: Date, totalCountOfStans: Int) {
        self.day = day
        self.totalCountOfStans = totalCountOfStans
    }
}

@Model
class StanDataDetailed {
    var stanStartDate: Date
    var stanEndDate: Date
    var pauseStartDate: [Date] = []
    var pauseEndDate: [Date] = []
    
    init(stanStartDate: Date) {
        self.stanStartDate = stanStartDate
        self.stanEndDate = stanStartDate //TODO: Think about how to implement it
    }
}
