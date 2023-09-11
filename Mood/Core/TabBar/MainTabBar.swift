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
            Text("Moods")
                .tabItem {
                    Image(systemName: "globe.americas")
                }
            
            Text("Your Health")
                .tabItem {
                    Image(systemName: "brain")
                }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainTabBar()
}
