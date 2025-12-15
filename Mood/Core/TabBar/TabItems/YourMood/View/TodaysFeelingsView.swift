//
//  TodaysFeelingsView.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI
import Charts

enum ChartSortType: String, CaseIterable, Identifiable {
    case name = "name"
    case impact = "impact"
    
    var id: String {self.rawValue}
}

enum ChartSortDirection: String, CaseIterable, Identifiable {
    case ascending = "ascending"
    case descending = "descending"
    
    var id: String {self.rawValue}
}

struct TodaysFeelingsChart: View {
//    @EnvironmentObject var dataService: DataService
    var contextLogContainers: [ContextLogContainer]
    
    var maxXScale: Double {
        return (contextLogContainers.map{ Double($0.totalWeight) }.max() ?? 4.0)+0.5
    }
    
    init(contextLogContainers: [ContextLogContainer]) {
        self.contextLogContainers = contextLogContainers
        
        for clc in contextLogContainers {
            clc.moodContainers = clc.moodContainers.sorted {$0.weight.rawValue > $1.weight.rawValue}
        }
    }
    
    var body: some View {
        Chart(contextLogContainers, id:\.contextId) { logContainer in
            ForEach(logContainer.moodContainers, id: \.emotions) { moodContainer in
                BarMark(
                    x: .value("weight", moodContainer.weight.rawValue == 0 ? 0.05 : Double(moodContainer.weight.rawValue)),
                    y: .value("context", logContainer.contextName)
                )
                .foregroundStyle(Mood.getMood(from: moodContainer.moodName)?.getColor() ?? .appPurple)
                .cornerRadius(5)
                .annotation(
                    position: moodContainer.weight.rawValue == 0 ? .trailing : .overlay,
                    alignment: .trailing,
                    spacing: 5
                ) {
                    Text(moodContainer.emotions[0])
                        .font(.caption)
                        .foregroundStyle(
                            moodContainer.weight.rawValue == 0 ? .appBlack :
                                Color(moodContainer.moodName).optimalForegroundColor()
                        )
                }
            }
        }
        .frame(height: (CGFloat(contextLogContainers.count) * 60.0)+40)
        .chartXScale(domain: [0, maxXScale])
        .chartYAxis {
            AxisMarks(stroke: StrokeStyle(lineWidth: 0))
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("impact")
        }
        .chartXAxis {
            AxisMarks() { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    EmptyView()
                }
            }
        }
    }
}

struct TodaysFeelingsView: View {
    @EnvironmentObject var dataService: DataService
    @ObservedObject var analytics = AnalyticsGenerator.shared
    @AppStorage("feelingsChartSortType") var chartSortType: ChartSortType = .impact
    @AppStorage("feelingsChartSortDirection") var chartSortDirection: ChartSortDirection = .ascending
    
    @State var impactStatement: String = ""
    @State var chartData: [ContextLogContainer] = []
    let listFormatter = ListFormatter()
    
    private func cp(_ text: String, state: PrintableStates = .none) {
        let finalString = "🖼️\(state.rawValue) TODAYS FEELINGS VIEW: " + text
        print(finalString)
    }
    
    func createImpactStatement(from items: [String]) -> String {
        
        if items.count == 0 {
            return "No items"
        }
        
        else {
            return listFormatter.string(from: items) ?? "No items"
        }
    }
    
    func sortChartData() {
        if let data = dataService.todaysDailyData {
            
            switch chartSortType {
            case .impact:
                switch chartSortDirection {
                case .ascending:
                    chartData = data.contextLogContainers.sorted {$0.totalWeight < $1.totalWeight}
                case .descending:
                    chartData = data.contextLogContainers.sorted {$0.totalWeight > $1.totalWeight}
                }
                
            case .name:
                switch chartSortDirection {
                case .ascending:
                    chartData = data.contextLogContainers.sorted {$0.contextName < $1.contextName}
                case .descending:
                    chartData = data.contextLogContainers.sorted {$0.contextName > $1.contextName}
                }
                
            }
            
        }
    }
    
    var body: some View {
        if dataService.todaysDailyData != nil {
            VStack(alignment: .leading){
                Text("today's feelings")
                    .fontWeight(.bold)
                    .foregroundStyle(.appBlack.opacity(0.5))
                    .font(.title3)
                    .padding(.top, 5)
                
                
                Text("**\(impactStatement)** had the biggest impact on you")
                    .padding(.bottom, 10)
                
                HStack {
                    Picker("sorted by", selection: $chartSortType) {
                        ForEach(ChartSortType.allCases) { type in
                            Text("\(type.rawValue)").tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("sort order", selection: $chartSortDirection) {
                        ForEach(ChartSortDirection.allCases) { type in
                            if type == .ascending {
                                Image(systemName: "arrow.up").tag(type)
                            } else if type == .descending {
                                Image(systemName: "arrow.down").tag(type)
                            } else {
                                Text("\(type.rawValue)").tag(type)
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
                
                Spacer()
                TodaysFeelingsChart(contextLogContainers: chartData)
                    .onChange(of: chartSortType, initial: true) {
                        sortChartData()
                    }
                    .onChange(of: chartSortDirection, initial: true) {
                        sortChartData()
                    }
            }
            .onChange(of: dataService.todaysDailyData, initial: true) {
                analytics.calculateTBI()
                if let data = dataService.todaysDailyData {
                    chartData = data.contextLogContainers
                    sortChartData()
                }
                
                cp("todays biggest impacts changed")
                print("\(analytics.todaysBiggestImpacts)")
                impactStatement = createImpactStatement(from: analytics.todaysBiggestImpacts)
            }
        }
//        else {
//            VStack{
//            }
//        }
    }
}

#Preview {
    @Previewable var randomData = DailyData.randomData(count: 15)
    VStack {
        TodaysFeelingsView()
            .environmentObject(DataService.shared)
            
        Button {
            DataService.shared.todaysDailyData = randomData.randomElement()
        } label: {
            Text("new data")
        }
    }
    .onAppear {
        DataService.shared.todaysDailyData = randomData.randomElement()
    }
}
