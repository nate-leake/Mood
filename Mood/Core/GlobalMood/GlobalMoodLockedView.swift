//
//  GlobalMoodLockedView.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI

struct GlobalMoodLockedView: View {
    var logWindowOpen: Bool
    
    var body: some View {
        VStack(spacing: 20){
            if logWindowOpen {
                Image(systemName: "lock.circle.dotted")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.appBlack, .appPurple)
                    .font(.system(size: 100))
                
                
                Text("Log your mood to view global data")
                    .font(.title3)
            } else {
                Image(systemName: "clock")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.appBlack, .appPurple)
                    .font(.system(size: 100))
                
                
                Text("Reflect on your day before logging")
                    .font(.title3)
            }
        }
    }
}

#Preview {
    GlobalMoodLockedView(logWindowOpen: true)
}
