//
//  ContextTileView.swift
//  Mood
//
//  Created by Nate Leake on 9/19/24.
//

import SwiftUI

struct ContextTile: View {
    var context: Context
    var frameSize: CGFloat
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: context.iconName)
                .font(.system(size: 50))
                .opacity(0.5)
                .padding(.top)
            Spacer()
            Text(context.name)
                .padding(.bottom)
        }
        .foregroundStyle(context.color.isLight() ? .black : .white)
        .frame(width: frameSize, height: frameSize)
        .background(context.color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct ContextTileView: View {
    @StateObject var viewModel: UploadMoodViewModel = UploadMoodViewModel()
    @State var selectedContext: Context?
    
    var contexts: [Context] = Context.allContexts
    
    private static let size: CGFloat = 150
    
    let layout = [
        GridItem(.adaptive(minimum:size), spacing: 0),
        GridItem(.adaptive(minimum:size), spacing: 0)
    ]
    
    var body: some View {
        VStack {
            if !viewModel.pairs.isEmpty{
                NavigationLink{
                    MoodLoggedView()
                        .environmentObject(viewModel)
                } label: {
                    HStack{
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(.appBlue)
                        Text("finish")
                        Spacer()
                    }
                    .font(.headline)
                    .foregroundStyle(.appBlack)
                    .frame(height: 44)
                    .background(.appBlue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            }
            ScrollView{
                LazyVGrid(columns: layout) {
                    ForEach(contexts, id:\.self) { context in
                        Button(
                            action: {
                                if !(viewModel.containsPair(withContext: context.name) ){
                                    self.selectedContext = context
                                }
                            }, label: {
                                if (viewModel.containsPair(withContext: context.name) ){
                                    ZStack {
                                        ContextTile(context: context, frameSize: ContextTileView.size)
                                            .opacity(0.5)
                                        VStack{
                                            ZStack{
                                                HStack{
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundStyle(.appBlack)
                                                    Text("logged")
                                                        .foregroundStyle(.appBlack)
                                                }
                                                .padding(.vertical, 2)
                                                .frame(maxWidth: .infinity)
                                                .background(.white.opacity(0.5))
                                            }
                                            Spacer()
                                        }
                                    }
                                    .frame(width: ContextTileView.size, height: ContextTileView.size)
                                    .background(.appWhite.opacity(0.7))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    
                                } else {
                                    ContextTile(context: context, frameSize: ContextTileView.size)
                                }
                            }
                        )
                        .padding(.bottom)
                    }
                }
            }
        }
        .navigationTitle("select a context to log about")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: self.$selectedContext) { context in
            ContextLogView(context: context)
                .environmentObject(viewModel)
        }
        
    }
}

#Preview {
    ContextTileView()
}
