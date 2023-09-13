//
//  GlobalMoodView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI

struct GlobalMoodView: View {
    var body: some View {
        NavigationStack {
            Text("This is the global mood data")
            
            .navigationTitle("Global mood")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GlobalMoodView()
}
