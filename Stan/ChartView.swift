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
    //@Query(sort: \StanData.day) var stanData: [StanData]
    @Environment(\.openWindow) private var openWindow
    var stanData: [StanData] = []
    
    var body: some View {
        VStack {
            Text("Session Count")
                .font(.title)
                .fontDesign(.serif)
                .padding(.bottom, 10)
            //.foregroundColor(Color(red: 238/255, green: 238/255, blue: 238/255))
            
            Chart(stanData, id: \.day) { stan in
                BarMark(
                    x: .value("Day", stan.day, unit: .day),
                    y: .value("Count", stan.totalCountOfStans)
                )
                .annotation(position: .top, alignment: .center) {
                    Text("\(stan.totalCountOfStans)")
                }
                .cornerRadius(3)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                    AxisValueLabel(format: .dateTime.weekday().day(), centered: true)
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600*24*7)
            .padding()
        }
        .frame(minWidth: 300, minHeight: 200)
        .padding()
        .background {
            GradientBackground()
        }
        .toolbar {
            Button(action:
                    { openWindow(id: "data-screen")}) {
                Image(systemName: "dots.and.line.vertical.and.cursorarrow.rectangle").fontWeight(.light)
            }
            
        }
    }
}

func generateMockStanData() -> [StanData] {
    let calendar = Calendar.current
    let currentDate = Date()
    
    // Generate mock data for the past 30 days
    return (0..<30).map { offset in
        let date = calendar.date(byAdding: .day, value: -offset, to: currentDate) ?? currentDate
        let totalCountOfStans = Int.random(in: 10...100) // Random count between 10 and 100
        return StanData(day: date, totalCountOfStans: totalCountOfStans)
    }
}

// Preview with mock data
#Preview {
    ChartView(stanData: generateMockStanData())
}


