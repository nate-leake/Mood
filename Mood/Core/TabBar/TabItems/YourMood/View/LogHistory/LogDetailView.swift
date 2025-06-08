//
//  LogDetailView.swift
//  Mood
//
//  Created by Nate Leake on 1/26/25.
//

import SwiftUI

struct LogItemView: View {
    var contextLogContainer: ContextLogContainer
    var context: UnsecureContext
    
    init(contextLogContainer: ContextLogContainer) {
        self.contextLogContainer = contextLogContainer
        self.context = UnsecureContext.getContext(from: contextLogContainer.contextId)!
    }
    
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
                ForEach(contextLogContainer.moodContainers, id: \.moodName) {log in
                    HStack(alignment: .top) {
                        Text("\(log.moodName)")
                            .frame(width:100)
                            .padding(7)
                            .background(Color(log.moodName))
                            .foregroundStyle(Color(log.moodName).isLight() ? .black : .white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            ForEach(log.emotions, id:\.self) { text in
                                Text(text)
                                    .frame(maxWidth: .infinity)
                                    .padding(7)
                                    .background(Color(log.moodName).opacity(0.5))
                                //                                    .foregroundStyle(Color(log.moodName).opacity(0.5).isLight() ? .black : .white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.leading, 5)
                    }
                    .padding(.vertical, 7)
                }
                
            }
            .modifier(ListRowBackgroundModifer())
        }
    }
}

struct LogDetailView: View {
    @Environment(\.dismiss) var dismiss
    var post: UnsecureMoodPost
    @State var isShowingConfirmation: Bool = false
    
    var body: some View {
        
        List{
            ForEach(post.contextLogContainers, id: \.contextId) { container in
                LogItemView(contextLogContainer: container)
            }
            
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("\(ShortDate().string(from: post.timestamp))")
        .navigationBarTitleDisplayMode(.inline)
        .withToolbarDeleteButton(deleteMessage: "this action will permenantly erase this log. this action cannot be undone.") {
            Task {
                print("delete day")
                let result = try await DataService.shared.deleteMoodPost(postID: post.id)
                
                switch result {
                case .success(_):
                    dismiss()
                case .failure(let error):
                    print("error deleting mood post: \(error)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        LogDetailView(post: UnsecureMoodPost.MOCK_DATA[1])
    }
}
