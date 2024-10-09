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
    @State private var isLoading: Bool = true
    @State private var loadingSuccess:Bool = false
    @State private var recentMoods: [(mood: String, intensity: Int)]?
    @State private var totalMoodScore: Int = 0
    
    var body: some View {
        NavigationStack {
            List {
                // checks if the user has logged alreay
                // and that if they have not logged yet that the logging window is open
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
                        YourMoodsChartsView()
                    } label: {
                        
                        HStack {
                            if loadingSuccess {
                                
                                VStack{
                                    HStack{
                                        Text("recent moods")
                                            .fontWeight(.bold)
                                            .foregroundStyle(.appBlack.opacity(0.5))
                                        Spacer()
                                    }
                                    if recentMoods?.count ?? 0 > 0 {
                                        Spacer()
                                        HStack {
                                            if let recentMoodData = recentMoods{
                                                WrappingMoodKey(items: recentMoodData, maxDisplayed: 4)
                                            }
                                            Spacer()
                                        }
                                    } else {
                                        Text("charts will be availble after you log your mood at least once")
                                            .padding(.vertical)
                                    }
                                    
                                }
                                Spacer()
                                if recentMoods?.count ?? 0 > 0 {
                                    Chart {
                                        if let recentMoodData = recentMoods {
                                            ForEach(recentMoodData.prefix(4), id: \.mood) { data in
                                                SectorMark(angle: .value("mood", (data.intensity*100 / totalMoodScore)), innerRadius: .ratio(0.618), angularInset: 1.5)
                                                    .foregroundStyle(Mood(name: data.mood, emotions: []).getColor())
                                                    .cornerRadius(5)
                                            }
                                        }
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 70)
                                }
                                
                            }
                            else {
                                VStack{
                                    HStack{
                                        Text("recent moods")
                                            .fontWeight(.bold)
                                            .foregroundStyle(.appBlack.opacity(0.5))
                                        Spacer()
                                    }
                                    Spacer()
                                    
                                }
                                Spacer()
                                Chart {
                                    
                                    SectorMark(angle: .value("mood", 1),
                                               innerRadius: .ratio(0.618),
                                               angularInset: 1.5)
                                    .foregroundStyle(.appPurple)
                                    .cornerRadius(5)
                                    
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 70)
                            }
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
        }
        .scrollContentBackground(.hidden)
        
        .navigationTitle("your moods")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: dailyDataService.recentMoodPosts, initial: true){
            Task {
                do {
                    totalMoodScore = 0
                    loadingSuccess = false
                    isLoading = true
                    
                    if let moodPosts = dailyDataService.recentMoodPosts {
                        let ag = AnalyticsGenerator()
                        let tmp = ag.aggregateMoodIntensityByDate(moodPosts: moodPosts)
                        recentMoods = ag.aggregateMoodIntensityTotals(moodData: tmp)
                        
                        for mood in recentMoods?.prefix(4) ?? [] {
                            totalMoodScore += mood.intensity
                        }
                        
                        if totalMoodScore == 0 {
                            totalMoodScore = 1
                        }
                        
                        withAnimation(.easeInOut){loadingSuccess = true}
                    } else {
                        
                        withAnimation(.easeInOut){loadingSuccess = false}
                    }
                }
                withAnimation(.easeInOut){isLoading = false}
            }
        }
        
    }
}

#Preview {
    YourMoodView()
        .environmentObject(DailyDataService())
}
