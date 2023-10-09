//
//  YourMoodView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI
import Charts

struct MoodData: Identifiable {
    var id: UUID {return UUID()}
    var date: Date
    var mood: Mood
    var weight: Weight
    
    static var happyExample: [MoodData] = [
        .init(date: Date(), mood: Mood.allMoods[0], weight: .moderate),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, mood: Mood.allMoods[0], weight: .slight),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, mood: Mood.allMoods[0], weight: .extreme)
    ]
    
    static var sadExample: [MoodData] = [
        .init(date: Date(), mood: Mood.allMoods[1], weight: .none),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, mood: Mood.allMoods[1], weight: .none),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, mood: Mood.allMoods[1], weight: .none)
    ]
    
    static var fearExample: [MoodData] = [
        .init(date: Date(), mood: Mood.allMoods[2], weight: .slight),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, mood: Mood.allMoods[2], weight: .slight),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, mood: Mood.allMoods[2], weight: .none)
    ]
    
    static var angerExample: [MoodData] = [
        .init(date: Date(), mood: Mood.allMoods[3], weight: .slight),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, mood: Mood.allMoods[3], weight: .extreme),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, mood: Mood.allMoods[3], weight: .slight)
    ]
    
    static var neutralExample: [MoodData] = [
        .init(date: Date(), mood: Mood.allMoods[4], weight: .moderate),
        .init(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, mood: Mood.allMoods[4], weight: .slight),
        .init(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, mood: Mood.allMoods[4], weight: .slight)
    ]
}

struct YourMoodView: View {
    
    @State private var hasLoggedToday : Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                if !hasLoggedToday {
                    Section {
                        Text("log today's mood")
                            .fontWeight(.bold)
                            .foregroundStyle(.appBlack.opacity(0.75))
                            .modifier(ListRowBackgroundModifer(foregroundColor: .appYellow))
                        LogDailyMoodSuggestionView(hlt: self.$hasLoggedToday)
                            .modifier(ListRowBackgroundModifer())
                            .padding(.vertical, 10)
                    }
                    
                }
                
                Section {
                    NavigationLink{
                        Text("More charts go here!")
                    } label: {
                        HStack {
                            VStack{
                                HStack{
                                    Text("recent moods")
                                        .fontWeight(.bold)
                                        .foregroundStyle(.appBlack.opacity(0.5))
                                    Spacer()
                                }
                                Spacer()
                                HStack{
                                    HStack{
                                        HStack{
                                            Circle()
                                                .fill(.happiness)
                                                .frame(width: 5)
                                            Text("happy")
                                                .font(.caption)
                                        }
                                        
                                        HStack{
                                            Circle()
                                                .fill(.anger)
                                                .frame(width: 5)
                                            Text("angry").font(.caption)
                                        }
                                    }
                                    HStack{
                                        
                                        HStack{
                                            Circle()
                                                .fill(.fearful)
                                                .frame(width: 5)
                                            Text("fearful").font(.caption)
                                        }
                                        
                                        HStack{
                                            Circle()
                                                .fill(.sadness)
                                                .frame(width: 5)
                                            Text("sad").font(.caption)
                                        }
                                    }
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            Spacer()
                            Chart {
                                SectorMark(angle: .value("mood", 23), innerRadius: .ratio(0.618), angularInset: 1.5)
                                    .foregroundStyle(.happiness)
                                    .cornerRadius(5)
                                
                                SectorMark(angle: .value("mood", 14), innerRadius: .ratio(0.618), angularInset: 1.5)
                                    .foregroundStyle(.anger)
                                    .cornerRadius(5)
                                
                                SectorMark(angle: .value("mood", 12), innerRadius: .ratio(0.618), angularInset: 1.5)
                                    .foregroundStyle(.fearful)
                                    .cornerRadius(5)
                                
                                SectorMark(angle: .value("mood", 9), innerRadius: .ratio(0.618), angularInset: 1.5)
                                    .foregroundStyle(.sadness)
                                    .cornerRadius(5)
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 70)
                        }
                        
                    }
                }
                .modifier(ListRowBackgroundModifer())
                
                Section {
                    NavigationLink {
                        Text("More charts go here too!!")
                    } label: {
                        HStack {
                            VStack{
                                Text("recent emotions")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.appBlack.opacity(0.5))
                                Spacer()
                            }
                            Spacer()
                            Chart {
                                BarMark(x: .value("logs", 20), y: .value("mood", "peaceful"))
                                    .foregroundStyle(.happiness)
                                    .cornerRadius(4)
                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
                                        Text("peaceful").font(.caption)
                                    })
                                
                                BarMark(x: .value("logs", 14), y: .value("mood", "confident"))
                                    .foregroundStyle(.happiness)
                                    .cornerRadius(4)
                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
                                        Text("confident").font(.caption)
                                    })
                                
                                BarMark(x: .value("logs", 12), y: .value("mood", "calm"))
                                    .foregroundStyle(.neutrality)
                                    .cornerRadius(4)
                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
                                        Text("calm").font(.caption)
                                    })
                                
                                BarMark(x: .value("logs", 9), y: .value("mood", "annoyed"))
                                    .foregroundStyle(.anger)
                                    .cornerRadius(4)
                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
                                        Text("annoyed").font(.caption)
                                    })
                            }
                            //                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 70)
                            .chartYAxis(.hidden)
                            .chartXAxis(.hidden)
                        }
                    }
                }
                .modifier(ListRowBackgroundModifer())
                
                if hasLoggedToday{
                    Section{
                        VStack{
                            HStack{
                                Text("today's feelings")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.appBlack.opacity(0.5))
                                    .padding(.vertical, 5)
                                Spacer()
                            }
                            HStack{
                                Text("**identity** had the biggest impact on you")
                                Spacer()
                            }
                            Spacer()
                            
                            Chart {
                                BarMark(x: .value("imapact", 1), y: .value("context", "family"))
                                    .foregroundStyle(.neutrality)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
                                        Text("indifferent").font(.caption)
                                    })
                                
                                BarMark(x: .value("impact", 1), y: .value("context", "health"))
                                    .foregroundStyle(.happiness)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
                                        Text("satisfied").font(.caption)
                                    })
                                
                                BarMark(x: .value("impact", 3), y: .value("context", "identity"))
                                    .foregroundStyle(.happiness)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
                                        Text("confident").font(.caption)
                                    })
                                
                                BarMark(x: .value("impact", 1), y: .value("context", "money"))
                                    .foregroundStyle(.neutrality)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
                                        Text("content").font(.caption)
                                    })
                                
                                BarMark(x: .value("imapact", 1), y: .value("context", "politics"))
                                    .foregroundStyle(.fearful)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
                                        Text("nervous").font(.caption)
                                    })
                                
                                BarMark(x: .value("imapact", 2), y: .value("context", "weather"))
                                    .foregroundStyle(.sadness)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
                                        Text("sad").font(.caption)
                                    })
                                
                                BarMark(x: .value("imapact", 2), y: .value("context", "work"))
                                    .foregroundStyle(.anger)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay, alignment: .trailing, spacing: 5, content: {
                                        Text("frusterated").font(.caption)
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
                    .modifier(ListRowBackgroundModifer())
                }
                
            }
            .scrollContentBackground(.hidden)
            
            .navigationTitle("your moods")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    YourMoodView()
}
