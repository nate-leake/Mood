//
//  RecentMoodsChart.swift
//  Mood
//
//  Created by Nate Leake on 9/4/24.
//

import SwiftUI
import Charts

struct MoodLineChartBreakdownView: View {
    @State var moodPosts: [UnsecureMoodPost]
    //    let viewingDataType: ViewingDataType
    var height: CGFloat
    
    @State var operationalData : [MoodData] = []
    @State var YAxisRangeMax: Int = 10
    
    var body: some View {

        ScrollView {
            ForEach(Mood.allMoodNames, id:\.self) { moodName in
                VStack(alignment: .leading){
                    Text("\(moodName)")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.5))
                    Chart {
                        ForEach(operationalData) { data in
                            if data.moodType == moodName {
                                LineMark(
                                    x: .value("date", data.date, unit: .day),
                                    y: .value("intensity", data.intensity)
                                )
                                .foregroundStyle(Color(moodName))
                                .interpolationMethod(.monotone)
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
                .padding()
            }
        }
        .navigationTitle("recent moods")
        
        .onAppear(
            perform: {
                operationalData = AnalyticsGenerator().aggregateMoodIntensityByDate(moodPosts: moodPosts)
                YAxisRangeMax = operationalData.map{$0.intensity}.max() ?? 8
                YAxisRangeMax += 2
            }
        )
    }
}

#Preview {
    MoodLineChartBreakdownView(
        moodPosts: UnsecureMoodPost.MOCK_DATA,
        height: 250
    )
}
