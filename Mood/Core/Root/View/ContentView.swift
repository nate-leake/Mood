//
//  ContentView.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    @StateObject var dailyDataService: DailyDataService = DailyDataService.shared
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                WelcomeView()
                    .environmentObject(registrationViewModel)
            } else if let currentUser = viewModel.currentUser {
                MainTabBar(user: currentUser)
                    .environmentObject(dailyDataService)
            }
        }
    }
}

#Preview {
    ContentView()
}
