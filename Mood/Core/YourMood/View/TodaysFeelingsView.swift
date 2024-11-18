//
//  TodaysFeelingsView.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI
import Charts

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
                Chart(dataService.todaysDailyData!.pairs, id:\.contextId) { pair in
                    BarMark(
                        x: .value("impact", pair.weight.rawValue == 0 ? 0.1 : Double(pair.weight.rawValue)),
                        y: .value("context", pair.contextName)
                    )
                    .foregroundStyle(Emotion(name: pair.emotions[0]).getParentMood()?.getColor() ?? .appPurple)
                    .cornerRadius(5)
                    .annotation(
                        position: pair.weight.rawValue == 0 ? .trailing : .overlay,
                        alignment: .trailing,
                        spacing: 5
                    ) {
                        Text(pair.emotions[0])
                            .font(.caption)
                            .foregroundStyle(
                                pair.weight.rawValue == 0 ? .appBlack :
                                    Emotion(name: pair.emotions[0]).getParentMood()?.getColor().isLight() ?? true ? .black : .white
                            )
                    }
                }
                .frame(height: (CGFloat(dataService.todaysDailyData?.pairs.count ?? 6) * 60.0)+40)
                .chartXScale(domain: [0, 3.55])
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
                            if let intValue = value.as(Int.self) {
                                switch intValue {
                                case 0: Text("none")
                                case 1: Text("slight")
                                case 2: Text("moderate")
                                case 3: Text("extreme")
                                default: EmptyView()
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: analytics.todaysBiggestImpacts, initial: true) {
                cp("todays biggest impacts changed")
                impactStatement = createImpactStatement(from: analytics.todaysBiggestImpacts)
            }
        }
        else {
            VStack{
                Text("Loading data...")
            }
        }
    }
}

#Preview {
    TodaysFeelingsView()
        .environmentObject(DataService())
}
