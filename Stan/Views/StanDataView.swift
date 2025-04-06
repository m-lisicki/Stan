//
//  StanDataView.swift
//  Stan
//
//  Created by Michał Lisicki on 12/01/2025.
//


import SwiftUI
import SwiftData

struct StanDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var stanData: [StanData]
    
    @State private var selectedStan: StanData? = nil
    @State private var selectedDate: Date = .now
    
    
    var body: some View {
        VStack {
            DatePicker("Select Date:", selection: $selectedDate, displayedComponents: .date)
                .onChange(of: selectedDate) { _, newDate in
                    selectedStan = stanData.first(where: { Calendar.current.isDate($0.day, inSameDayAs: newDate) })
                }
                .padding(.bottom, 7)
            ZStack {
                if let currentStan = selectedStan {
                    Stepper("Total Count of Stans: \(currentStan.totalCountOfStans)", value: Binding(
                        get: { currentStan.totalCountOfStans },
                        set: { newValue in
                            currentStan.totalCountOfStans = newValue
                            if newValue == 0 {
                                modelContext.delete(currentStan)
                                selectedStan = nil
                            }
                            try? modelContext.save()
                        }
                    ), in: 0...48) //we can assume maximum amount of stans possible = 2*24
                } else {
                    VStack {
                        Text("No Stan Data available for selected date")
                        Button(action: {
                            writeDefaultStan(for: selectedDate)
                        }) {
                            Text("Add First Entry")
                        }
                    }
                }
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding()
        .onAppear {
            selectedStan = stanData.first(where: { Calendar.current.isDate($0.day, inSameDayAs: selectedDate) })
        }
    }
    
    private func writeDefaultStan(for date: Date) {
        let newStan = StanData(day: date, totalCountOfStans: 1)
        modelContext.insert(newStan)
        
        try? modelContext.save()
        selectedStan = newStan
    }
}




// Preview
#Preview {
    StanDataView()
}
