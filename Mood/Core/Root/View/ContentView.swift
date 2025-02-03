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
    @StateObject var dataService: DataService = DataService.shared
    @StateObject var authService: AuthService = AuthService.shared
    @State var appStatus: AppStateCase = .startup
    @State var appEnteredBackgroundTime: Date = Date.now
    
    private func testMassUpload(){
        Task {
            DataService.shared.isPerformingManagedAGUpdate = true
            let context1 = "FB6EA42A-AC26-4D1A-9DCB-1E8FF1E1BDA3"
            for number in 1...200 {
                let emotion = "happy"
                let p1 = ContextLogContainer(contextId: context1, emotions: [emotion], weight: .extreme)
                let pairs: [ContextLogContainer] = [p1]
                let date = Date.now.addingTimeInterval(TimeInterval(-86400 * number))
                let data: DailyData = DailyData(date: date, timeZoneOffset: DailyData.TZO, pairs: pairs)
                let res = try await DataService.shared.uploadMoodPost(dailyData: data)
                
                print("CONTENT VIEW: uploaded pair \(number) with success: \(res)")
            }
            DataService.shared.isPerformingManagedAGUpdate = false
            AnalyticsGenerator.shared.calculateTBI(dataService: DataService.shared)
        }
    }
    
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
                            .environmentObject(dataService)
                            .onAppear{
//                                testMassUpload()
                            }
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
                    dataService.refreshServiceData()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
