//
//  ContextEditorView.swift
//  Mood
//
//  Created by Nate Leake on 10/20/24.
//

import SwiftUI

struct ContextSelectorView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var selectedContext: Context?
    @State var isShowingContextBuilder = false
        
    private static let size: CGFloat = 150
    
    let layout = [
        GridItem(.adaptive(minimum:size), spacing: 0),
        GridItem(.adaptive(minimum:size), spacing: 0)
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: layout) {
                ForEach(dataService.loadedContexts, id:\.id) { context in
                    Button{
                        selectedContext = context // Set the selected context
                        isShowingContextBuilder = true // Trigger navigation
                    } label: {
                        ContextTile(context: context, frameSize: ContextSelectorView.size)
                    }
                    .padding(.bottom)
                }
            }.navigationDestination(for: Context?.self) { context in
                ContextBuilderView(editingContext: context)
            }
            
            
        }
        .onChange(of: isShowingContextBuilder){ old, new in
            if old == true && new == false {
                if let context = selectedContext {
                    selectedContext = Context.getContext(from: context.id)
                }
            }
        }
        .navigationDestination(isPresented: $isShowingContextBuilder) {
            ContextBuilderView(editingContext: selectedContext)
        }
        .navigationTitle("edit contexts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink {
                    ContextBuilderView()
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
        .environmentObject(DataService())
}
