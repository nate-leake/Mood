//
//  LogDetailView.swift
//  Mood
//
//  Created by Nate Leake on 1/26/25.
//

import SwiftUI

struct LogItemView: View {
    var post: UnsecureMoodPost
    var context: UnsecureContext
    
    @State var moodLogContainers: [MoodLogContainer] = []
    
    var body: some View {
        Section{
            HStack {
                Image(systemName: context.iconName)
//                    .opacity(0.8)
                Text("\(context.name)")
                    .fontWeight(.bold)
//                    .opacity(0.8)
            }
            .foregroundStyle(context.color.isLight() ? .black : .white)
            .modifier(ListRowBackgroundModifer(foregroundColor: context.color.opacity(0.85)))
            
            VStack {
                ForEach(moodLogContainers, id: \.moodName) {log in
                    HStack {
                            
                        Text("\(log.moodName)")
                            .padding(10)
                            .background(Color(log.moodName))
                            .foregroundStyle(Color(log.moodName).isLight() ? .black : .white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        Text("\(log.emotions.joined(separator: ", "))")
                            
                        
                        Spacer()
                    }
                }
                
            }
            .modifier(ListRowBackgroundModifer())
        }
        .onAppear{
            moodLogContainers = []
            print(post)
            for pair in post.data { // loop through each ContextEmotionPair in the post (there can be multiple CEPs for one context)
//                print(pair.contextId, context.id)
                if pair.contextId == context.id { // check if the CEP matches the current context
                    moodLogContainers = pair.moodContainers
                }
            }
            print(moodLogContainers)
        }
    }
}

struct LogDetailView: View {
    var post: UnsecureMoodPost
    
    var body: some View {
        
        List{
            ForEach(post.data, id: \.contextId) { data in
                if let context = UnsecureContext.getContext(from: data.contextId){
                    LogItemView(post: post, context: context)
                } else {
                    Text("nil context\n\(data.contextId)")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("\(ShortDate().string(from: post.timestamp))")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    NavigationStack{
        LogDetailView(post: UnsecureMoodPost.MOCK_DATA[1])
    }
}
