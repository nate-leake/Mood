//
//  ContentView.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("lockAppOnBackground") var lockAppOnBackground: Bool = true
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    @StateObject var dailyDataService: DailyDataService = DailyDataService.shared
    @StateObject var authService: AuthService = AuthService.shared
    @State var appStatus: AppStateCase = .startup
    @State var appEnteredBackgroundTime: Date = Date.now
    
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
        .onChange(of: scenePhase) { old, new in
            if lockAppOnBackground && new == .background{
                authService.lock()
                appEnteredBackgroundTime = Date.now
            }
            if new == .inactive && old == .background {
                if Date().timeIntervalSince(appEnteredBackgroundTime) > 600 {
                    dailyDataService.refreshServiceData()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
