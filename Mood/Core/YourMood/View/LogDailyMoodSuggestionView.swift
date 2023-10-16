//
//  LogDailyMoodSuggestionView.swift
//  Mood
//
//  Created by Nate Leake on 10/4/23.
//

import SwiftUI

struct LogDailyMoodSuggestionView: View {
    @StateObject var model = LogDailyMoodViewModel()
    @Binding var hlt: Bool
    @State var showingSheet = false
    
    var body: some View {
        VStack(alignment: .leading){
            
            HStack{
                Text("logging consistently can help build awareness")
                    .font(.system(.callout))
                    .opacity(0.8)
                
                Spacer()
                
                Button{
//                    withAnimation {
//                        hlt = true
//                        print(hlt)
//                    }
                    showingSheet.toggle()
                } label: {
                    Text("log")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                        .foregroundStyle(.white)
                        .background(.appPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .fullScreenCover(isPresented: $showingSheet){
                    NavigationStack{
                        LogMoodView(contexts: ["family","health","identity","finances","politics","weather","work"], isPresented: $showingSheet)
                            .environmentObject(model)
                    }
                }
            }
        }
    }
}

#Preview {
    @State var logger = false
    
    return LogDailyMoodSuggestionView(hlt: $logger)
}
