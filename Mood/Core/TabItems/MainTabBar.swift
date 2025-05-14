//
//  MainTabBar.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

enum TabItem {
    case yourMood, toolsAndObjectives, profile
}

class TabBarManager: ObservableObject {
    @Published var tabBarVisibility: Visibility = .visible
    
    static var shared = TabBarManager()
    
    func hideTabBar() {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.tabBarVisibility = .hidden
        }
    }
    
    func unhideTabBar() {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.tabBarVisibility = .visible
        }
    }
}

struct MainTabBar: View {
    // selection var forces the default selected tab to match the tag assigned to that tabItem
    @EnvironmentObject var dataService: DataService
    @State var selected: Int = 1
    @ObservedObject var tabViewManager: TabBarManager = TabBarManager.shared
    let user: User
    
    var body: some View {
        TabView(selection: $selected) {
//            GlobalMoodViewWrapper()
//                .environmentObject(dataService)
//                .tabItem {
//                    Image(systemName: "globe.americas")
//                }
//                .tag(1)
            
            YourMoodView()
                .environmentObject(dataService)
                .tabItem {
                    Image(systemName: "brain")
                }
                .tag(1)
                .toolbar(tabViewManager.tabBarVisibility, for: .tabBar)
            
            ToolsAndObjectivesView()
                .environmentObject(dataService)
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver.fill")
                }
                .tag(2)
                .toolbar(tabViewManager.tabBarVisibility, for: .tabBar)
            
            ProfileView(user: user)
                .environmentObject(dataService)
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
                .toolbar(tabViewManager.tabBarVisibility, for: .tabBar)
            
        }
        
    }
}

#Preview {
    MainTabBar(user: User.MOCK_USERS[0])
        .environmentObject(DataService())
}
