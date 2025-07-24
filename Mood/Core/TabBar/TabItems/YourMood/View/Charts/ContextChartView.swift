//
//  ContextChartView.swift
//  Mood
//
//  Created by Nate Leake on 7/5/25.
//

import SwiftUI
import Charts

struct ContextChartView: View {
    @EnvironmentObject var dataService: DataService
    @EnvironmentObject var chartService: ChartService
    @AppStorage("chartsViewingDaysBackSelection") private var chartsViewingDaysBack: Int = 14
    var context: UnsecureContext
    @State var dataPoints: [MoodData] = []
    @State var pieChartData: [PieChartData] = []
    @State var lineChartData: [LineChartData] = []
    @State var moodPostSourceCount: Int = 0
    @State var chartSelection: String?
    
    var body: some View {
        VStack {
            ZStack() {
                Color(context.color).ignoresSafeArea()
                VStack {
                    
                    Text("\(Image(systemName: context.iconName)) \(context.name)")
                        .font(.title2)
                        .padding(.bottom, 7)
                    
                }
            }
            .foregroundStyle(context.color.optimalForegroundColor())
            .frame(height: 30)
            
            SegmentedTimePickerView()
                .padding(.top, 3)
                .padding(.horizontal, 24)
            
            Text("using ^[\(dataPoints.count) data point](inflect: true) sourced from ^[\(moodPostSourceCount) log](inflect: true)")
                .font(.footnote)
                .opacity(0.8)
            
            PieChart(chartData: pieChartData, chartSelection: $chartSelection)
                .frame(height: 170)
                .padding(.vertical, 10)
            
            MultiSeriesLineChart(chartData: lineChartData, selectedSeries: chartSelection)
                .frame(height: 200)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
            
            Spacer()
        }
        .onChange(of: chartsViewingDaysBack, initial: true) {
            dataPoints = []
            moodPostSourceCount = 0
            chartSelection = nil
            //            print("there are \(context.associatedPostIDs.count) post ids for this context")
            
            for associatedPostId in context.associatedPostIDs {
                
                let posts = chartService.moodPostsAfterPickerSelection(viewingDaysBack: chartsViewingDaysBack)
                //                let posts = dataService.loadedMoodPosts!
                //#warning("posts are currently configured for previews only")
                
                if let post = posts.first(where: { $0.id == associatedPostId }) {
                    moodPostSourceCount += 1
                    let contextLogContainers = post.contextLogContainers
                    //                    print("\(post.id) on \(post.timestamp.shortDate())")
                    
                    // at least one clc should contain the correct context id
                    for clc in contextLogContainers {
                        if clc.contextId == context.id {
                            for mlc in clc.moodContainers {
                                dataPoints.append(MoodData(date: post.timestamp, contextId: context.id, moodType: mlc.moodName, intensity: mlc.weight.rawValue))
                            }
                            //                            print("post \(post.id) contains context id with date \(post.timestamp.shortDate())")
                            
                        }
                    }
                    
                }
            }
            
            dataPoints = dataPoints.sorted(by: { $0.date > $1.date })
            
            pieChartData = ChartService.shared.generatePieChartData(moodData: dataPoints)
            lineChartData = ChartService.shared.generateLineChartData(moodData: dataPoints)
            //            print("there are \(dataPoints.count) data points")
        }
    }
    
}

#Preview {
    @Previewable @StateObject var dataService = DataService.shared
    @Previewable @StateObject var chartService = ChartService.shared
    
    if dataService.loadedContexts.count > 0 {
        ContextChartView(context: dataService.loadedContexts[0])
            .environmentObject(dataService)
            .environmentObject(chartService)
    } else {
        Text("setting up...")
            .onAppear {
                dataService.previewSetup()
            }
    }
    
}
