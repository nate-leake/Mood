//
//  GlobalMoodLockedView.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI

struct GlobalMoodLockedView: View {
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "lock.circle.dotted")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.black, .appPurple)
                .font(.system(size: 100))
                
            
            Text("Log your mood to view global data")
                .font(.title3)
        }
    }
}

#Preview {
    GlobalMoodLockedView()
}
