//
//  MainTabBar.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct MainTabBar: View {
    var body: some View {
        TabView{
            GlobalMoodView()
                .tabItem {
                    Image(systemName: "globe.americas")
                }
            
            YourMoodView()
                .tabItem {
                    Image(systemName: "brain")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    MainTabBar()
}
