//
//  ContentView.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                WelcomeView()
            } else {
                MainTabBar()
            }
        }
    }
}

#Preview {
    ContentView()
}
