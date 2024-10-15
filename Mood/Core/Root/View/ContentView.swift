//
//  ContentView.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    @StateObject var dailyDataService: DailyDataService = DailyDataService.shared
    @StateObject var authService: AuthService = AuthService.shared
    @State var appStatus: AppStateCase = .startup
    
    var body: some View {
        Group{
            if appStatus != .ready {
                AppLoadingView(appState: $appStatus)
            } else {
                if !(authService.userIsSignedIn ?? false) {
                    WelcomeView()
                        .environmentObject(registrationViewModel)
                } else if let currentUser = viewModel.currentUser {
                    if authService.isUnlocked{
                        MainTabBar(user: currentUser)
                            .environmentObject(dailyDataService)
                    } else {
                        ValidatePinView()
                            .onChange(of: authService.isUnlocked) { old, new in
                                print("old: \(old), new: \(new)")
                            }
                    }
                }
            }
        }
        .onChange(of: scenePhase) { new, old in
            print(scenePhase)
            if new == .background {
                authService.lock()
            }
        }
    }
}

#Preview {
    ContentView()
}
