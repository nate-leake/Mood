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
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                WelcomeView()
                    .environmentObject(registrationViewModel)
            } else {
                MainTabBar()
            }
        }
    }
}

#Preview {
    ContentView()
}
