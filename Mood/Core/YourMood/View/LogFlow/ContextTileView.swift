//
//  ContextTileView.swift
//  Mood
//
//  Created by Nate Leake on 9/19/24.
//

import SwiftUI

struct ContextTile: View {
    @ObservedObject var context: UnsecureContext
    var frameSize: CGFloat
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: context.iconName)
                .font(.system(size: 50))
                .opacity(0.75)
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
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: UploadMoodViewModel = UploadMoodViewModel()
    @ObservedObject var dataService: DataService = DataService.shared
    @State var selectedContext: UnsecureContext?
    
    private static let size: CGFloat = 150
    
    let layout = [
        GridItem(.adaptive(minimum:size), spacing: 0),
        GridItem(.adaptive(minimum:size), spacing: 0)
    ]
    
    var body: some View {
        ZStack {
            ScrollView{
                LazyVGrid(columns: layout) {
                    ForEach(DataService.shared.loadedContexts, id:\.id) { context in
                        if !context.isHidden {
                            Button(
                                action: {
                                    if !(viewModel.containsPair(withContextId: context.id) ){
                                        self.selectedContext = context
                                    }
                                }, label: {
                                    if (viewModel.containsPair(withContextId: context.id) ){
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
                if !viewModel.pairs.isEmpty {
                    Rectangle()
                        .frame(height: 44)
                        .background(.clear)
                        .foregroundStyle(.clear)
                }
            }
            if !viewModel.pairs.isEmpty{
                VStack{
                    Spacer()
                    ZStack{
                        NavigationLink{
                            MoodLoggedView()
                                .environmentObject(viewModel)
                        } label: {
                            HStack{
                                Spacer()
                                Image(systemName: "checkmark")
                                    .opacity(0.8)
                                
                                Text("finish")
                                
                                Spacer()
                            }
                            .foregroundStyle(.appWhite)
                            .font(.headline)
                            .frame(height: 44)
                            .background(.appBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        
                    }
                }
            }
            
        }
        .onChange(of: viewModel.isUploaded) { old, new in
            if !old && new {
                
                // This delay is dependant on the MoodLoggedView timer array
                _ = Timer.scheduledTimer(withTimeInterval: 4.7, repeats: false) { (closeTimer) in
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("select a context to log about")
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
        .fullScreenCover(item: self.$selectedContext) { context in
            ContextLogView(context: context)
                .environmentObject(viewModel)
        }
        
    }
}

#Preview {
    ContextTileView()
        .onAppear{
            DataService.shared.loadedContexts = UnsecureContext.defaultContexts
        }
}
