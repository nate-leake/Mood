//
//  LineChart.swift
//  Mood
//
//  Created by Nate Leake on 7/11/25.
//

import SwiftUI
import Charts

struct ChartScaleModifier<X: Plottable & Comparable, Y: Plottable & Comparable>: ViewModifier {
    var xDomain: ClosedRange<X>?
    var yDomain: ClosedRange<Y>?

    func body(content: Content) -> some View {
        var modified = AnyView(content)

        if let x = xDomain {
            modified = AnyView(modified.chartXScale(domain: x))
        }

        if let y = yDomain {
            modified = AnyView(modified.chartYScale(domain: y))
        }

        return modified
    }
}

struct SingleSeriesLineChart<X: Plottable & Comparable, Y: Plottable & Comparable>: View {
    var chartData: [LineChartData]
    var xDomain: ClosedRange<X>? = nil
    var yDomain: ClosedRange<Y>? = nil
    
    private func lineMark(item: LineChartData) -> some ChartContent {
        let lineWidth: CGFloat = 2
        let frameSize: CGFloat = 10
        let color = item.color
        
        let mark: some ChartContent = LineMark(
            x: .value("date", item.date),
            y: .value("intensity", item.value)
        )
        .foregroundStyle(color)
        .interpolationMethod(.catmullRom)
        .lineStyle(.init(lineWidth: lineWidth))
        .symbol {
            Circle()
                .fill(color)
                .frame(width: frameSize, height: frameSize)
        }
        
        return mark
        
    }
    
    var body: some View {
        Chart {
            ForEach(chartData, id: \.category) { item in
                lineMark(item: item)
            }
        }
        .modifier(ChartScaleModifier(xDomain: xDomain, yDomain: yDomain))
        
    }
}

struct MultiSeriesLineChart: View {
    var chartData: [LineChartData]
    var selectedSeries: String?
    var legendVisibility: Visibility = .hidden
    
    var chartStyleScale: KeyValuePairs<String, Color> {
        if selectedSeries != nil {
            [
                "anger": selectedSeries == "anger" ? Color.anger : Color.anger.mix(with: .gray, by: 0.3),
                "fearful": selectedSeries == "fearful" ? Color.fearful : Color.fearful.mix(with: .gray, by: 0.3),
                "happiness": selectedSeries == "happiness" ? Color.happiness : Color.happiness.mix(with: .gray, by: 0.3),
                "neutrality": selectedSeries == "neutrality" ? Color.neutrality : Color.neutrality.mix(with: .gray, by: 0.3),
                "sadness": selectedSeries == "sadness" ? Color.sadness : Color.sadness.mix(with: .gray, by: 0.3)
            ]
        } else {
            [
                "anger":  Color.anger,
                "fearful": Color.fearful,
                "happiness": Color.happiness,
                "neutrality": Color.neutrality,
                "sadness": Color.sadness
            ]
        }
    }
    
    private func lineMark(item: LineChartData) -> some ChartContent {
        let lineWidth = CGFloat(selectedSeries == nil ? 2 : (selectedSeries == item.category ? 3 : 1))
        let opacity = (selectedSeries == nil ? 1 : (selectedSeries == item.category ? 1 : 0.3))
        let frameSize = CGFloat(selectedSeries == nil ? 10 : (selectedSeries == item.category ? 12 : 8))
        let zIndex = Double(selectedSeries == nil ? 1 : (selectedSeries == item.category ? 3 : 1))
        let color = selectedSeries == nil ? item.color : (selectedSeries == item.category ? item.color : item.color.mix(with: .gray, by: 0.3))
        
        let mark: some ChartContent = LineMark(
            x: .value("date", item.date),
            y: .value("intensity", item.value)
        )
        .foregroundStyle(by: .value("category", item.category))
        .opacity(opacity)
        .zIndex(zIndex)
        .interpolationMethod(.catmullRom)
        .lineStyle(.init(lineWidth: lineWidth))
        .symbol {
            Circle()
                .fill(color)
                .frame(width: frameSize, height: frameSize)
                .opacity(opacity)
        }
        
        return mark
        
    }
    
    var body: some View {
        Chart {
            ForEach(chartData, id: \.category) { item in
                
                lineMark(item: item)
                
            }
        }
        .chartForegroundStyleScale(chartStyleScale)
        .chartLegend(legendVisibility)
    }
}

#Preview("multi series") {
    @Previewable @StateObject var dataService: DataService = DataService.shared
    @Previewable @StateObject var analyticsGenerator: AnalyticsGenerator = AnalyticsGenerator.shared
    @Previewable @StateObject var chartService: ChartService = ChartService.shared

    @Previewable @State var chartData: [LineChartData] = []
    @Previewable @State var selectedSeries = "fearful"

    MultiSeriesLineChart(chartData: chartData, selectedSeries: selectedSeries)
        .frame(height: 300)
        .onAppear{
            dataService.previewSetup(numberOfDays: 10)
            let moodData = analyticsGenerator.aggregateMoodIntensityByDate(moodPosts: dataService.loadedMoodPosts ?? [])
            chartData = ChartService.shared.generateLineChartData(moodData: moodData)
        }
    
}

#Preview("single series") {
    @Previewable @StateObject var dataService: DataService = DataService.shared
    @Previewable @StateObject var analyticsGenerator: AnalyticsGenerator = AnalyticsGenerator.shared
    @Previewable @StateObject var chartService: ChartService = ChartService.shared

    @Previewable @State var chartData: [LineChartData] = []
    
    SingleSeriesLineChart<Date, Int>(chartData: chartData, xDomain:
        Calendar.current.date(byAdding: .day, value: -14, to: Date())!...Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    )
        .frame(height: 300)
        .onAppear{
            dataService.previewSetup(numberOfDays: 10)
            let moodData = analyticsGenerator.aggregateMoodIntensityByDate(moodPosts:  dataService.loadedMoodPosts ?? [])
                .filter {$0.moodType == "happiness"}
            chartData = ChartService.shared.generateLineChartData(moodData: moodData)
        }
}
