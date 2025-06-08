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
            if frameSize >= 75 {
            Spacer()
            Image(systemName: context.iconName)
                .font(.system(size: frameSize/3))
                .opacity(0.75)
                .padding(.top)
            Spacer()
                Text(context.name)
                    .padding(.bottom)
            } else {
                Spacer()
                Image(systemName: context.iconName)
                    .font(.system(size: frameSize/2))
                    .opacity(0.75)
                Spacer()
            }
        }
        .foregroundStyle(context.color.isLight() ? .black : .white)
        .frame(width: frameSize, height: frameSize)
        .background(context.color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct ContextButton: View {
    @EnvironmentObject var viewModel: UploadMoodViewModel
    @Binding var selectedContext: UnsecureContext?
    @State var wasLoggedAbout: Bool = false
    var context: UnsecureContext
    var frameSize: CGFloat
    
    var body: some View {
        Button(
            action: {
                if !wasLoggedAbout {
                    self.selectedContext = context
                }
            }, label: {
                if wasLoggedAbout {
                    ZStack {
                        ContextTile(context: context, frameSize: frameSize)
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
                    .frame(width: frameSize, height: frameSize)
                    .background(.appWhite.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                } else {
                    ContextTile(context: context, frameSize: frameSize)
                }
            }
        )
        .onChange(of: viewModel.contextLogContainers){
            withAnimation(.easeInOut) {
                wasLoggedAbout = viewModel.containsContextLogContainer(withContextId: context.id)
            }
            print("context \(context.id) logged: \(wasLoggedAbout))")
        }
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
                            ContextButton(selectedContext: $selectedContext,
                                          context: context,
                                          frameSize: ContextTileView.size)
                            .environmentObject(viewModel)
                            .padding(.bottom)
                        }
                    }
                }
                if !viewModel.contextLogContainers.isEmpty {
                    Rectangle()
                        .frame(height: 44)
                        .background(.clear)
                        .foregroundStyle(.clear)
                }
                TabBarSpaceReservation()
            }
            if !viewModel.contextLogContainers.isEmpty{
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
                    TabBarSpaceReservation()
                }
            }
            
        }
        .onChange(of: viewModel.isUploaded) { old, new in
            if !old && new {
                
                // This delay is dependant on the MoodLoggedView timer array
                _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (closeTimer) in
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("select a context to log about")
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
