//
//  RecentMoodsChart.swift
//  Mood
//
//  Created by Nate Leake on 9/4/24.
//

import SwiftUI
import Charts

enum ViewingDataType: String {
    case context = "context"
    case mood = "mood"
}

extension Binding {
    // Helper initializer for creating a Binding with a default value when the optional is nil
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

struct LineChartWithSelection: View {
    @State var moodPosts: [MoodPost]
    let viewingDataType: ViewingDataType
    var height: CGFloat
    
    @State var operationalData : [MoodData] = []
    @State var currentSelection: String?
    @State var options: [String] = []
    let prompt: String = "select"
    
    func prepareData(moodPosts: [MoodPost]){
        var tmpData: [MoodData] = []
        for post in moodPosts {
            for pair in post.data {
                tmpData.append(
                    MoodData(date: Calendar.current.startOfDay(for: post.timestamp),
                             context: pair.context,
                             moodType: Emotion(name: pair.emotions[0]).getParentMood()?.name ?? "none",
                             intensity: pair.weight.rawValue)
                )
            }
        }
        
        if viewingDataType == .context {
            options = ["family", "finances", "health", "identity", "politics", "weather", "work"]
        } else if viewingDataType == .mood {
            options = Mood.allMoodNames
            
            // Dictionary to hold aggregated values
            var aggregatedData: [String: [String: Int]] = [:] // [date: [moodType: intensity]]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Assumes dates are formatted by day
            
            for data in tmpData {
                let dateKey = dateFormatter.string(from: data.date)
                if aggregatedData[dateKey] == nil {
                    aggregatedData[dateKey] = [:]
                }
                aggregatedData[dateKey]![data.moodType, default: 0] += data.intensity
            }
            
            // Convert aggregated data back to MoodData
            var result: [MoodData] = []
            
            for (dateString, moodTypes) in aggregatedData {
                guard let date = dateFormatter.date(from: dateString) else { continue }
                for (moodType, intensity) in moodTypes {
                    result.append(MoodData(date: date, context: "", moodType: moodType, intensity: intensity))
                }
            }
            
            // Ensure each day has exactly 5 mood types
            let expectedMoodTypes: Set<String> = Set(options) // Update with your specific mood types
            
            var finalResult: [MoodData] = []
            
            // Iterate through dates to check for missing mood types
            let groupedByDate = Dictionary(grouping: result, by: { dateFormatter.string(from: $0.date) })
            
            for (dateString, moods) in groupedByDate {
                guard let date = dateFormatter.date(from: dateString) else { continue }
                let existingMoodTypes = Set(moods.map { $0.moodType })
                let missingMoodTypes = expectedMoodTypes.subtracting(existingMoodTypes)
                
                finalResult.append(contentsOf: moods)
                
                // Add missing mood types with intensity 0
                for moodType in missingMoodTypes {
                    finalResult.append(MoodData(date: date, context: "", moodType: moodType, intensity: 0))
                }
            }
            
            operationalData = finalResult
            
            operationalData = operationalData.sorted{ $0.date < $1.date }
            
        }
    }
    
    
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                Chart {
                    ForEach($operationalData, id:\.id) { data in
                        
                        if let selection = currentSelection {
                            if viewingDataType == .context{
                                if selection == data.context.wrappedValue {
                                    LineMark(
                                        x: .value("date", data.date.wrappedValue, unit: .day),
                                        y: .value("intensity", data.intensity.wrappedValue)
                                    )
                                    .foregroundStyle(.appPurple)
                                    .interpolationMethod(.monotone)
                                }
                            }
                            
                            else if viewingDataType == .mood{
                                if selection == data.moodType.wrappedValue {
                                    LineMark(
                                        x: .value("date", data.date.wrappedValue, unit: .day),
                                        y: .value("intensity", data.intensity.wrappedValue)
                                    )
                                    .foregroundStyle(Mood(name: data.moodType.wrappedValue, emotions: []).getColor())
                                    .interpolationMethod(.monotone)
                                    
                                }
                            }
                        }
                        
                        
                        
                    }
                }
                .frame(height: height-80)
                //                .chartYScale(domain: [0, 6])
                .chartXScale(domain: .automatic) // Fixed X-axis range for past 7 days
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(format: .dateTime.weekday(), centered: true) // Display the weekday on the X-axis
                        AxisTick(centered: true)
                        AxisGridLine(centered: true)
                    }
                    
                }
            }
            
            
            VStack {
                DropDownView(
                    title: viewingDataType.rawValue,
                    prompt: prompt,
                    options: options,
                    selection: $currentSelection
                )
                .padding(.horizontal)
                .zIndex(1)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            .onAppear(
                perform: {
                    prepareData(moodPosts: moodPosts)
                }
            )
        }
        .frame(height: height)
    }
}

#Preview {
    LineChartWithSelection(
        moodPosts: MoodPost.MOCK_DATA,
        viewingDataType: .mood,
        height: 250
    )
}
