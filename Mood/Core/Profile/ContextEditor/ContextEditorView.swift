//
//  ContextEditorView.swift
//  Mood
//
//  Created by Nate Leake on 10/20/24.
//

import SwiftUI

struct ContextEditorView: View {
    @EnvironmentObject var dataService: DataService
    
    @State var selectedContext: Context?
    
    var contexts: [Context] = Context.allContexts
    
    private static let size: CGFloat = 150
    
    let layout = [
        GridItem(.adaptive(minimum:size), spacing: 0),
        GridItem(.adaptive(minimum:size), spacing: 0)
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: layout) {
                ForEach(contexts, id:\.self) { context in
                    Button(
                        action: {
                            self.selectedContext = context
                        }, label: {
                            ContextTile(context: context, frameSize: ContextEditorView.size)
                        }
                    )
                    .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    ContextEditorView()
        .environmentObject(DataService())
}
