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
    @State var appStatus: AppStateCase = .startup
    
    var body: some View {
        Group{
            if appStatus != .ready {
                AppLoadingView(appState: $appStatus)
            } else {
                if !(AuthService.shared.userIsSignedIn ?? false) {
                    WelcomeView()
                        .environmentObject(registrationViewModel)
                } else if let currentUser = viewModel.currentUser {
                    MainTabBar(user: currentUser)
                        .environmentObject(dailyDataService)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
