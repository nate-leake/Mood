//
//  ContextEditorView.swift
//  Mood
//
//  Created by Nate Leake on 10/20/24.
//

import SwiftUI

struct ContextSelectorView: View {
    @Namespace private var contextsNamespace
    @EnvironmentObject var dataService: DataService
    
    @State var isShowingHidden = false
    
    private static let size: CGFloat = 150
    
    let layout = [
        GridItem(.adaptive(minimum:size), spacing: 0),
        GridItem(.adaptive(minimum:size), spacing: 0)
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: layout) {
                ForEach(dataService.loadedContexts, id:\.id) { context in
                    if !context.isHidden{
                        NavigationLink {
                            EditContextView(editing: context)
                                .navigationTransition(.zoom(sourceID: context.id, in: contextsNamespace))
                        } label: {
                            ContextTile(context: context, frameSize: ContextSelectorView.size)
                                .padding(.bottom, 10)
                        }
                        .matchedTransitionSource(id: context.id, in: contextsNamespace)
                        
//                        Button{
//                            selectedContext = context // Set the selected context
//                            isShowingContextBuilder = true // Trigger navigation
//                        } label: {
//                            if context.isDeleting {
//                                DeletingContextTile(context: context)
//                            } else {
//                                ContextTile(context: context, frameSize: ContextSelectorView.size)
//                            }
//                        }
                        
                    }
                }
            }
            
            Divider()
        
            Button{
                withAnimation(.easeInOut){
                    isShowingHidden.toggle()
                }
            } label: {
                HStack{
                    Spacer()
                    Image(systemName: isShowingHidden ? "eye.slash" : "eye")
                    Spacer()
                    Text(isShowingHidden ? "hide items" : "show items")
                        .frame(width: 100)
                    Spacer()
                }
                .frame(width: 150, height: 34)
                .background(.appPurple)
                .foregroundStyle(.appWhite)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            if isShowingHidden {
                LazyVGrid(columns: layout) {
                    ForEach(dataService.loadedContexts, id:\.id) { context in
                        if context.isHidden {
                            NavigationLink {
                                EditContextView(editing: context)
                                    .navigationTransition(.zoom(sourceID: context.id, in: contextsNamespace))
                            } label: {
                                ContextTile(context: context, frameSize: ContextSelectorView.size)
                                    .padding(.bottom, 10)
                            }
                            .matchedTransitionSource(id: context.id, in: contextsNamespace)
                            
//                            Button{
//                                selectedContext = context // Set the selected context
//                                isShowingContextBuilder = true // Trigger navigation
//                            } label: {
//                                if context.isDeleting {
//                                    DeletingContextTile(context: context)
//                                } else {
//                                    ContextTile(context: context, frameSize: ContextSelectorView.size)
//                                }
//                            }
//                            .padding(.bottom)
                        }
                    }
                }
            }
            Rectangle()
                .fill(.clear)
                .frame(height: 60)
        }
        .navigationTitle("edit contexts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink {
                    AddContextView()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    ContextSelectorView()
        .environmentObject(DataService.shared)
        .onAppear {
            DataService.shared.loadedContexts = UnsecureContext.defaultContexts
        }
}
