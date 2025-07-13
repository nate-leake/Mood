//
//  RecentMoodsChart.swift
//  Mood
//
//  Created by Nate Leake on 9/4/24.
//

import SwiftUI
import Charts

struct MoodLineChart: View {
    var moodName: String
    var operationalData: [MoodData]
    var numberOfDaysVisible: Int
    var YAxisRangeMax: Int = 10
    var height: CGFloat = 250
    
    private var viewingUnits: Calendar.Component {
        if numberOfDaysVisible <= 14 {
            return .day
        } else if numberOfDaysVisible == 30 {
            return .weekOfMonth
        } else {
            return .month
        }
    }
    
    private var addingDaysAhead: Int {
        if numberOfDaysVisible == 7 {
            return 0
        } else if numberOfDaysVisible == 14 {
            return 1
        } else if numberOfDaysVisible == 30 {
            return 5
        } else {
            return 15
        }
    }
    
    var body: some View {
        
        Chart(operationalData) { moodData in
            if moodData.moodType == moodName {
                LineMark(
                    x: .value("date", moodData.date, unit: viewingUnits),
                    y: .value("intensity", moodData.intensity)
                )
                .foregroundStyle(Color(moodName))
                .interpolationMethod(.monotone)
            }
        }
        .frame(height: height-80)
//        .chartXVisibleDomain(length: 86400 * numberOfDaysVisible)
        .chartYScale(domain: [0, YAxisRangeMax])
        .chartXScale(
            domain: [
                Calendar.current.date(byAdding: .day, value: -numberOfDaysVisible, to: Date())!,
                Calendar.current.date(byAdding: .day, value: addingDaysAhead, to: Date())!
            ]
        ) // Fixed X-axis range for past 7 days
//        .chartXAxis {
//            AxisMarks(values: .stride(by: .day)) { value in
//                AxisValueLabel(format: .dateTime, centered: true) // Display the weekday on the X-axis
//                AxisTick(centered: true)
//                AxisGridLine(centered: true)
//            }
//        }
        
    }
}

struct MoodLineChartBreakdownView: View {
    @EnvironmentObject var moodPostTracker: ChartMoodPostTracker
    @AppStorage("chartsViewingDaysBackSelection") private var chartsViewingDaysBack: Int = 14
    //    let viewingDataType: ViewingDataType
    var height: CGFloat = 250
    
    @State var operationalData : [MoodData] = []
    @State var YAxisRangeMax: Int = 10
    
    var body: some View {

        ScrollView {
            ForEach(Mood.allMoodNames, id:\.self) { moodName in
                VStack(alignment: .leading){
                    Text("\(moodName)")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.5))
                    

                    MoodLineChart(
                        moodName: moodName,
                        operationalData: operationalData,
                        numberOfDaysVisible: chartsViewingDaysBack,
                        YAxisRangeMax: YAxisRangeMax
                    )

                    //                    Chart {
//                        ForEach(operationalData) { data in
//                            if data.moodType == moodName {
//                                LineMark(
//                                    x: .value("date", data.date, unit: .day),
//                                    y: .value("intensity", data.intensity)
//                                )
//                                .foregroundStyle(Color(moodName))
//                                .interpolationMethod(.monotone)
//                            }
//                        }
//                    }
//                    .frame(height: height-80)
//                    .chartYScale(domain: [0, YAxisRangeMax])
//                    .chartXScale(domain: .automatic) // Fixed X-axis range for past 7 days
//                    .chartXAxis {
//                        AxisMarks(values: .stride(by: .day)) { value in
//                            AxisValueLabel(format: .dateTime, centered: true) // Display the weekday on the X-axis
//                            AxisTick(centered: true)
//                            AxisGridLine(centered: true)
//                        }
//                    }
                }
                .padding()
            }
        }
        .navigationTitle("recent moods")
        .onChange(of: moodPostTracker.moodPosts, initial: true) { old, new in
            withAnimation(.smooth(duration: 0.3)) {
                operationalData = []
                operationalData = AnalyticsGenerator().aggregateMoodIntensityByDate(moodPosts: new)
                YAxisRangeMax = operationalData.map{$0.intensity}.max() ?? 8
                YAxisRangeMax += 2
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var postTracker = ChartMoodPostTracker()
    
    @Previewable @State var viewingDaysBack: Int = 14
    @Previewable @State var opData = AnalyticsGenerator().aggregateMoodIntensityByDate(moodPosts: UnsecureMoodPost.MOCK_DATA)
    @Previewable @State var YAxisRangeMax = 10
    
    MoodLineChartBreakdownView()
    .environmentObject(postTracker)
    .onAppear {
        postTracker.moodPosts = UnsecureMoodPost.MOCK_DATA
    }
}

//#Preview {
//    @Previewable @State var viewingDaysBack: Int = 14
//    @Previewable @State var opData = AnalyticsGenerator().aggregateMoodIntensityByDate(moodPosts: UnsecureMoodPost.MOCK_DATA)
//    @Previewable @State var YAxisRangeMax = 10
//    
//    VStack {
//        Picker("days back", selection: $viewingDaysBack) {
//            Text("90 days").tag(90)
//            Text("30 days").tag(30)
//            Text("2 weeks").tag(14)
//            Text("1 week").tag(7)
//        }
//        .pickerStyle(.segmented)
//        .padding(.horizontal, 24)
//        
//        MoodLineChart(
//            moodName: "happiness",
//            operationalData: opData,
//            numberOfDaysVisible: viewingDaysBack,
//            YAxisRangeMax: YAxisRangeMax
//        )
//        .onAppear{
//            YAxisRangeMax = opData.map{$0.intensity}.max() ?? 8
//            YAxisRangeMax += 2
//        }
//    }
//}
