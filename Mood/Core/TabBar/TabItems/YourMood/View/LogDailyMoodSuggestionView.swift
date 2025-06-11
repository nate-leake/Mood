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
            HStack{
                Text("logging consistently can help build awareness")
                    .font(.system(.callout))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.appBlack)
                
                Spacer()
                
                NavigationLink{
                    ContextTileView()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            
                        Text("log")
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 7, leading: 11, bottom: 7, trailing: 13))
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
