//
//  TodaysFeelingsView.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI
import Charts

struct TodaysFeelingsView: View {
    @EnvironmentObject var dailyDataService: DailyDataService
    @State var todaysData: DailyData?
    var analytics = AnalyticsGenerator()
    
    var body: some View {
        if todaysData != nil {
            VStack{
                HStack{
                    Text("today's feelings")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.5))
                        .padding(.vertical, 5)
                    Spacer()
                }
                HStack{
                    Text("**\(analytics.biggestImpact(data: [todaysData!])[0])** had the biggest impact on you")
                    Spacer()
                }
                Spacer()
                
                Chart(todaysData!.pairs, id: \.context) { pair in
                    
                    BarMark(x: .value("imapact", pair.weight.rawValue==0 ? 0.1 : Double(pair.weight.rawValue)), y: .value("context", pair.context))
                        .foregroundStyle(Emotion(name: pair.emotions[0]).getParentMood()?.getColor() ?? .appPurple)
                        .cornerRadius(5)
                        .annotation(position: pair.weight.rawValue==0 ? .trailing : .overlay, alignment: .trailing, spacing: 5, content: {
                            Text(pair.emotions[0]).font(.caption)
                        })
                    
                }
                .aspectRatio(0.9, contentMode: .fit)
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
                                if intValue == 0 {
                                    Text("none")
                                } else if intValue == 1 {
                                    Text("slight")
                                }
                                else if intValue == 2 {
                                    Text("moderate")
                                }
                                else if intValue == 3 {
                                    Text("extreme")
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            VStack{
                Text("Loading data...")
            }
            .onChange(of: dailyDataService.todaysDailyData) {
                print("daily data changed!")
                if let data = dailyDataService.todaysDailyData {
                    self.todaysData = data
                    print(self.todaysData ?? "no data can be printed")
                } else {
                    print("todays feelings could not be loaded")
                }
            }
            .onAppear{
                if let data = dailyDataService.todaysDailyData{
                    self.todaysData = data
                    print(self.todaysData ?? "no data can be printed")
                } else {
                    print("todays feelings could not be loaded")
                }
            }
        }
        
        
    }
}

#Preview {
    TodaysFeelingsView()
}
