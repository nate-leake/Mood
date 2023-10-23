//
//  MainTabBar.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct MainTabBar: View {
    @EnvironmentObject var dailyDataService: DailyDataService
    let user: User
    
    var body: some View {
        TabView{
            GlobalMoodView()
                .environmentObject(dailyDataService)
                .tabItem {
                    Image(systemName: "globe.americas")
                }
            
            YourMoodView()
                .environmentObject(dailyDataService)
                .tabItem {
                    Image(systemName: "brain")
                }
            
            ProfileView(user: user)
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    MainTabBar(user: User.MOCK_USERS[0])
}
