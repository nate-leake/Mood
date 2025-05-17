//
//  TodaysFeelingsView.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI
import Charts

struct TodaysFeelingsChart: View {
    @EnvironmentObject var dataService: DataService
    
    var body: some View {

        Chart(dataService.todaysDailyData!.contextLogContainers, id:\.contextId) { logContainer in
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
                                Mood.getMood(from: moodContainer.moodName)?.getColor().isLight() ?? true ? .black : .white
                        )
                }
            }
        }
        .frame(height: (CGFloat(dataService.todaysDailyData?.contextLogContainers.count ?? 6) * 60.0)+40)
        .chartXScale(domain: [
            0,
            (dataService.todaysDailyData?.contextLogContainers.map{ Double($0.totalWeight) }.max() ?? 4.0)+0.5
        ])
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
    @State var impactStatement: String = ""
    
    private func cp(_ text: String, state: PrintableStates = .none) {
        let finalString = "🖼️\(state.rawValue) TODAYS FEELINGS VIEW: " + text
        print(finalString)
    }
    
    func createImpactStatement(from items: [String]) -> String {
        switch items.count {
        case 0:
            return "No items"
        case 1:
            return "\(items[0])"
        case 2:
            return "\(items[0]) and \(items[1])"
        default:
            let allButLast = items.dropLast().joined(separator: ", ")
            let lastItem = items.last!
            return "\(allButLast), and \(lastItem)"
        }
    }
    
    var body: some View {
        if dataService.todaysDailyData != nil {
            VStack{
                HStack{
                    Text("today's feelings")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.5))
                        .padding(.vertical, 5)
                    Spacer()
                }
                HStack{
                    Text("**\(impactStatement)** had the biggest impact on you")
                    Spacer()
                }
                Spacer()
                TodaysFeelingsChart()
            }
            .onChange(of: analytics.todaysBiggestImpacts, initial: true) {
                cp("todays biggest impacts changed")
                print("\(analytics.todaysBiggestImpacts)")
                impactStatement = createImpactStatement(from: analytics.todaysBiggestImpacts)
            }
        }
        else {
            VStack{
                Text("Loading data...")
                    .onAppear{
                        DataService.shared.todaysDailyData = DailyData.MOCK_DATA[1]
//                        print(DataService.shared.todaysDailyData?.contextLogContainers.count ?? "no daily data")
                        
//                        AnalyticsGenerator.shared.calculateTBI()
                    }
            }
        }
    }
}

#Preview {
    TodaysFeelingsView()
        .environmentObject(DataService.shared)
}
