//
//  PieChart.swift
//  Mood
//
//  Created by Nate Leake on 7/11/25.
//

import SwiftUI
import Charts

struct PieChart: View {
    var chartData: [PieChartData]
    var totalWeightScore: Int {
        var total = 0
        for point in chartData {
            total += point.value
        }
        return total
    }
    @Binding var chartSelection: String?
    @State private var chartSelectionRange: Double? = nil
    
    init(chartData: [PieChartData], chartSelection: Binding<String?>) {
        self.chartData = chartData.sorted(by: {$0.value > $1.value})
//        self.chartData = ChartService().generatePieChartData(moodData: MoodData.MOCK_DATA).sorted(by: {$0.value > $1.value})
        self._chartSelection = chartSelection
    }
    
    private func findSelectedSector(rangeValue: Double)  {
        var initialValue: Double = 0.0
        let convertedArray = chartData.compactMap{ data -> (String, Range<Double>)
            in
            let rangeEnd = initialValue + Double(data.value)
            let tuple = (data.category, initialValue..<rangeEnd)
            initialValue = rangeEnd
            return tuple
        }
        
        if let data: (String, Range<Double>) = convertedArray.first(
            where: {
                $0.1.contains(rangeValue)
            }
        ) {
            chartSelection = data.0
        }
    }
    
    func calcPercent(intensity: Int) -> String {
        let percent = (Double(intensity) * 100.0) / Double(totalWeightScore)
        
        let percentString = percent.roundedString(toPlaces: 1)
        
        return percentString
    }
    
    func key() -> some View {
        OverflowLayout {
            VStack {
                if chartData.count > 0 {
                    ForEach(0...(chartData.count - 1), id: \.self) { index in
                        let percent = calcPercent(intensity: chartData[index].value)
                        let opacity = chartSelection == nil ? 1 : (chartSelection == chartData[index].category ? 1 : 0.4)
                        let circleSize = CGFloat(chartSelection == nil ? 10 : (chartSelection == chartData[index].category ? 12 : 7))
                        let color = chartSelection == nil ? chartData[index].color : (chartSelection == chartData[index].category ? chartData[index].color : chartData[index].color.mix(with: .gray, by: 0.3))
                        
                        HStack(alignment: .center){
                            Circle()
                                .fill(color)
                                .frame(width: circleSize)
                            Text("\(chartData[index].category) \(percent)%")
                                .font(.callout)
                                .foregroundStyle(.appBlack)
                                .bold(chartSelection == chartData[index].category)
                            Spacer()
                        }
                        .opacity(opacity)
                        .onTapGesture{
                            let tappedSelection = chartData[index].category
                            if let cs = chartSelection {
                                if cs == tappedSelection {
                                    chartSelection = nil
                                } else {
                                    chartSelection = tappedSelection
                                }
                            } else {
                                chartSelection = tappedSelection
                            }
                        }
                        
                    }
                } else {
                    HStack(alignment: .center){
                        Circle()
                            .fill(Color.appPurple)
                            .frame(width: 10)
                        Text("no data")
                            .font(.callout)
                            .foregroundStyle(.appBlack)
                        Spacer()
                    }
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            if chartData.count > 0 {
                ZStack {
//                    if let selection = chartSelection {
//                        Text(selection)
//                    }
                    
                    Chart {
                        
                        ForEach(chartData) { data in
                            let color = chartSelection == nil ? data.color : (chartSelection == data.category ? data.color : data.color.mix(with: .gray, by: 0.3))
                            
                            SectorMark(angle: .value("mood",data.value), innerRadius: .ratio(0.618), angularInset: 1.5)
                                .foregroundStyle(color)
                                .cornerRadius(5)
                                .opacity(chartSelection == nil ? 1 : (chartSelection == data.category ? 1 : 0.4))
                        }
                        
                    }
                    .aspectRatio(contentMode: .fit)
                    .chartAngleSelection(value: $chartSelectionRange)
                    .onChange(of: chartSelectionRange, initial: false) { old, new in
                        if let new {
                            findSelectedSector(rangeValue: new)
                        }
                    }
                    .onTapGesture {
                        chartSelection = nil
                    }
                }
                
            } else {
                Chart {
                    
                    SectorMark(angle: .value("mood", 1), innerRadius: .ratio(0.618), angularInset: 1.5)
                        .foregroundStyle(Color.appPurple)
                        .cornerRadius(5)
                    SectorMark(angle: .value("mood", 1.5), innerRadius: .ratio(0.618), angularInset: 1.5)
                        .foregroundStyle(Color.appPurple)
                        .cornerRadius(5)
                    SectorMark(angle: .value("mood", 1), innerRadius: .ratio(0.618), angularInset: 1.5)
                        .foregroundStyle(Color.appPurple)
                        .cornerRadius(5)
                    
                }
                .aspectRatio(contentMode: .fit)
            }
            
            
            Spacer()
            
            key()
            
            Spacer()
            
        }
    }
}

#Preview {
    @Previewable @State var chartSelection: String?
    PieChart(chartData: ChartService().generatePieChartData(moodData: MoodData.MOCK_DATA), chartSelection: $chartSelection)
}
