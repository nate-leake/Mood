//
//  YourMoodView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI
import Charts



struct YourMoodView: View {
    @EnvironmentObject var dataService : DataService
    @State private var isLoading: Bool = true
    @State private var loadingSuccess:Bool = false
    @State private var recentMoods: [(mood: String, intensity: Int)]?
    @State private var totalMoodScore: Int = 0
    
    var body: some View {
        NavigationStack {
            List {
                // checks if the user has logged alreay
                // and that if they have not logged yet that the logging window is open
                if !dataService.userHasLoggedToday && dataService.logWindowOpen || true {
                    Section {
                        Text("log today's mood")
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.75))
                            .modifier(ListRowBackgroundModifer(foregroundColor: .appBlue))
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
                                        Spacer()
                                        if let recentMoodData = recentMoods{
                                            HStack{
                                                OverflowLayout {
                                                    ForEach(0...3, id:\.self) { index in
                                                        HStack{
                                                            Circle()
                                                                .fill(Mood(name: recentMoodData[index].mood, emotions: []).getColor())
                                                                .frame(width: 5)
                                                            Text(recentMoodData[index].mood)
                                                                .font(.caption)
                                                        }
                                                    }
                                                }
                                                Spacer()
                                            }
                                        }
                                        
                                        Spacer()
                                        
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
                
                if dataService.userHasLoggedToday{
                    Section{
                        TodaysFeelingsView()
                            .environmentObject(dataService)
                    }
                    .modifier(ListRowBackgroundModifer())
                }
                
                Section {
                    NavigationLink{
                        LogHistoryView()
                    } label: {
                        HStack {
                            VStack{
                                Text("log history")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.appBlack.opacity(0.5))
                                Spacer()
                            }
                            Spacer()
                            ZStack {
                                VStack(spacing: 10){
                                    HStack(spacing: 10){
                                        Image(systemName: "calendar")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(.appBlue)
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(.appRed)
                                    }
                                    HStack(spacing: 10){
                                        Image(systemName: "chart.line.uptrend.xyaxis")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(.appGreen)
                                        Image(systemName: "square.text.square.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(.appYellow)
                                    }
                                }
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .fontWeight(.ultraLight)
                                    .opacity(0.5)
                            }
                        }
                    }
                }
                .modifier(ListRowBackgroundModifer())
            }
        }
        .scrollContentBackground(.hidden)
        .onChange(of: dataService.recentMoodPosts, initial: true){
            Task {
                do {
                    totalMoodScore = 0
                    loadingSuccess = false
                    isLoading = true
                    
                    if let moodPosts = dataService.recentMoodPosts {
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
        .environmentObject(DataService())
}
