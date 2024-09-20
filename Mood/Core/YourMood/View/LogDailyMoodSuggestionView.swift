//
//  LogDailyMoodSuggestionView.swift
//  Mood
//
//  Created by Nate Leake on 10/4/23.
//

import SwiftUI

struct LogDailyMoodSuggestionView: View {
    @StateObject var model = UploadMoodViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            
                NavigationLink{
                    ContextTileView()
                } label: {
                    HStack{
                        Text("logging consistently can help build awareness")
                            .font(.system(.callout))
                        
                        Spacer()
                        
                    Text("log")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                        .foregroundStyle(.white)
                        .background(.appPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

#Preview {
    return LogDailyMoodSuggestionView()
}
