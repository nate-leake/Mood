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
    @State var moodPosts: [UnsecureMoodPost]
    let viewingDataType: ViewingDataType
    var height: CGFloat
    
    @State var operationalData : [MoodData] = []
    @State var YAxisRangeMax: Int = 10
    @State var currentSelection: String?
    @State var options: [String] = []
    let prompt: String = "select"
    
    
    
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
                .chartYScale(domain: [0, YAxisRangeMax])
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
                    if viewingDataType == .context {
                        options = ["family", "finances", "health", "identity", "politics", "weather", "work"]
                        for post in moodPosts {
                            for contextLogContainer in post.data {
                                let contextId = contextLogContainer.contextId
                                for moodContainer in contextLogContainer.moodContainers {
                                    operationalData.append(
                                        MoodData(date: Calendar.current.startOfDay(for: post.timestamp),
                                                 contextId: contextId,
                                                 moodType: moodContainer.moodName,
                                                 intensity: moodContainer.weight.rawValue)
                                    )
                                }
                            }
                        }
                    } else if viewingDataType == .mood {
                        options = Mood.allMoodNames
                        operationalData = AnalyticsGenerator().aggregateMoodIntensityByDate(moodPosts: moodPosts)
                        YAxisRangeMax = operationalData.map{$0.intensity}.max() ?? 8
                        YAxisRangeMax += 2
                    }
                }
            )
        }
        .frame(height: height)
    }
}

#Preview {
    LineChartWithSelection(
        moodPosts: UnsecureMoodPost.MOCK_DATA,
        viewingDataType: .mood,
        height: 250
    )
}
