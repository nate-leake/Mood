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
    var chartData: [LineChartData]
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
        
        SingleSeriesLineChart<Date, Int>(chartData: chartData)
            .frame(height: height-80)
            .chartYScale(domain: [0, YAxisRangeMax])
            .chartXScale(
                domain: [
                    Calendar.current.date(byAdding: .day, value: -numberOfDaysVisible, to: Date())!,
                    Calendar.current.date(byAdding: .day, value: addingDaysAhead, to: Date())!
                ]
            )
    }
}

struct MoodLineChartBreakdownView: View {
    @EnvironmentObject var moodPostTracker: ChartMoodPostTracker
    @AppStorage("chartsViewingDaysBackSelection") private var chartsViewingDaysBack: Int = 14
    //    let viewingDataType: ViewingDataType
    var height: CGFloat = 250
    
    @State var operationalData : [LineChartData] = []
    @State var YAxisRangeMax: Int = 10
    
    var body: some View {

        ScrollView {
            ForEach(Mood.allMoodNames, id:\.self) { moodName in
                let subChartData = operationalData.filter{ $0.category == moodName }
                VStack(alignment: .leading){
                    Text("\(moodName)")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.5))
                    

                    MoodLineChart(
                        moodName: moodName,
                        chartData: subChartData,
                        numberOfDaysVisible: chartsViewingDaysBack,
                        YAxisRangeMax: YAxisRangeMax
                    )
                }
                .padding()
            }
        }
        .navigationTitle("recent moods")
        .onChange(of: moodPostTracker.moodPosts, initial: true) { old, new in
            withAnimation(.smooth(duration: 0.3)) {
                operationalData = []
                let moodData = AnalyticsGenerator().aggregateMoodIntensityByDate(moodPosts: new)
                
                operationalData = ChartService.shared.generateLineChartData(moodData: moodData)
                YAxisRangeMax = operationalData.map{$0.value}.max() ?? 8
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
        Task {
            try await Task.sleep(nanoseconds: 1_000_000)
            postTracker.moodPosts = UnsecureMoodPost.MOCK_DATA
        }
    }
}

