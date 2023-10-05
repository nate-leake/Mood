//
//  LogDailyMoodSuggestionView.swift
//  Mood
//
//  Created by Nate Leake on 10/4/23.
//

import SwiftUI

struct LogDailyMoodSuggestionView: View {
    
    @Binding var hlt: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text("log today's mood")
                .fontWeight(.bold)
                .foregroundStyle(.appBlack.opacity(0.75))
            Rectangle()
                .frame(height: 0.5)
                .opacity(0.5)
            Spacer()
            
            HStack{
                Text("logging consistently can help build awareness")
                    .font(.system(.callout))
                    .opacity(0.8)
                
                Spacer()
                
                Button{
                    withAnimation {
                        hlt = true
                        print(hlt)
                    }
                } label: {
                    Text("log")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                        .foregroundStyle(.white)
                        .background(.appPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            
            Spacer()
        }
            
    }
}

#Preview {
    @State var logger = false
    
    return LogDailyMoodSuggestionView(hlt: $logger)
}
