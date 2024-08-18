//
//  YourMoodView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI
import Charts


struct YourMoodView: View {
    @EnvironmentObject var dailyDataService : DailyDataService
    @State private var hasLoggedToday : Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                if !dailyDataService.userHasLoggedToday && dailyDataService.logWindowOpen {
                    Section {
                        Text("log today's mood")
                            .fontWeight(.bold)
                            .foregroundStyle(.appBlack.opacity(0.75))
                            .modifier(ListRowBackgroundModifer(foregroundColor: .appYellow))
                        LogDailyMoodSuggestionView()
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
                
                if dailyDataService.userHasLoggedToday{
                    Section{
                        TodaysFeelingsView()
                            .environmentObject(dailyDataService)
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
