//
//  LogHistoryView.swift
//  Mood
//
//  Created by Nate Leake on 1/24/25.
//

import SwiftUI

struct LogHistoryView: View {
    @EnvironmentObject var dataService: DataService
    
    var body: some View {
        
        List{
            Section {
                Text("jan 26th")
                    .fontWeight(.bold)
                    .foregroundStyle(.appBlack.opacity(0.75))
                    .modifier(ListRowBackgroundModifer(foregroundColor: .appPurple.opacity(0.2).mix(with: .appBlack, by: 0.075)))
                
                NavigationLink {
                    Text("your info for jan 26")
                } label: {
                    HStack{
                        ContextTile(context: UnsecureContext.defaultContexts[0], frameSize: CGFloat(40))
                        ContextTile(context: UnsecureContext.defaultContexts[3], frameSize: CGFloat(40))
                        ContextTile(context: UnsecureContext.defaultContexts[2], frameSize: CGFloat(40))
                    }
                }
                .modifier(ListRowBackgroundModifer())
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("log histroy")
//        .navigationBarTitleDisplayMode(.automatic)
    }
    
}

#Preview {
    NavigationStack {
        LogHistoryView()
            .environmentObject(DataService())
    }
    
}
