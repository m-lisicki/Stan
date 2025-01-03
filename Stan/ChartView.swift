//
//  ChartView.swift
//  Stan
//
//  Created by Michał Lisicki on 05/01/2025.
//

import SwiftData
import Charts
import SwiftUI

struct ChartView: View {
    @Query(sort: \StanData.day) var stanData: [StanData]
    //var stanData: [StanData]
    
    //@State var scrollPosition = Int.max
    
    var body: some View {
        ZStack {
            GradientBackground()
            VStack {
                Text("Weekly Stan Counts")
                    .font(.title)
                    .fontDesign(.serif)
                    .padding(.bottom, 10)
                    //.foregroundColor(Color(red: 238/255, green: 238/255, blue: 238/255))
                
                Chart(stanData, id: \.day) {
                    BarMark(
                        x: .value("Day", $0.day, unit: .day),
                        y: .value("Count", $0.totalCountOfStans)
                    )
                }
                //.chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: 3600 * 24 * 7)
                /*.chartScrollPosition(x: $scrollPosition)
                .chartScrollTargetBehavior(
                    .valueAligned(
                        matching: DateComponents(hour: 0),
                        majorAlignment: .matching(DateComponents(day: 1))))
                 */
                .padding()
            }
            .frame(minWidth: 300, minHeight: 200)
            .padding()
        }
    }
}

func generateMockStanData() -> [StanData] {
    let calendar = Calendar.current
    let currentDate = Date()
    
    // Generate mock data for the past 7 days
    return (0..<30).map { offset in
        let date = calendar.date(byAdding: .day, value: -offset, to: currentDate) ?? currentDate
        let totalCountOfStans = Int.random(in: 10...100) // Random count between 10 and 100
        return StanData(day: date, totalCountOfStans: totalCountOfStans)
    }
}

// Preview with mock data
#Preview {
    //ChartView(stanData: generateMockStanData())
}


