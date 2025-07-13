//
//  ContextLogView.swift
//  Mood
//
//  Created by Nate Leake on 9/19/24.
//

import SwiftUI

struct MoodFormView: View {
    @ObservedObject var formManager: MoodFormManager
    @ObservedObject var formViewModel: MoodFormViewModel
    
    var animation: Animation = .easeInOut(duration: 0.25)
    
    var body: some View {
        VStack{
            MoodTagView(selectedMood: $formViewModel.selectedMood, assignedMoods: $formManager.takenMoods)
                .onChange(of: formViewModel.selectedMood){
                    withAnimation(.spring(response: 0.8)){
                        formViewModel.selectedEmotions = []
                        formViewModel.weight = .none
                    }
                }
            
            
            
            if formViewModel.selectedMood != nil {
                VStack{
                    Divider()
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    HStack{
                        Text("emotion")
                            .opacity(0.7)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    EmotionTagView(
                        selectedEmotions: $formViewModel.selectedEmotions,
                        mood: formViewModel.selectedMood ?? Mood.allMoods[0]
                    )
                }
            }
            
            
            if !formViewModel.selectedEmotions.isEmpty {
                VStack{
                    Divider()
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    HStack{
                        Text("intensity")
                            .opacity(0.7)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack{
                        HStack{
                            Text("none")
                                .padding(.all, 7)
                                .background(
                                    formViewModel.weight == .none ? formViewModel.selectedMood?
                                        .getColor() : .gray
                                        .opacity(0.3)
                                )
                                .foregroundStyle(
                                    formViewModel.weight == .none ?
                                    ((formViewModel.selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: formViewModel.weight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    formViewModel.weight = .none
                                }
                            
                            Text("slight")
                                .padding(.all, 7)
                                .background(
                                    formViewModel.weight == .slight ? formViewModel.selectedMood?
                                        .getColor() : .gray
                                        .opacity(0.3)
                                )
                                .foregroundStyle(
                                    formViewModel.weight == .slight ?
                                    ((formViewModel.selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: formViewModel.weight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    formViewModel.weight = .slight
                                }
                            
                            Text("moderate")
                                .padding(.all, 7)
                                .background(
                                    formViewModel.weight == .moderate ? formViewModel.selectedMood?
                                        .getColor() : .gray
                                        .opacity(0.3)
                                )
                                .foregroundStyle(
                                    formViewModel.weight == .moderate ?
                                    ((formViewModel.selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: formViewModel.weight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    formViewModel.weight = .moderate
                                }
                            
                            Text("extreme")
                                .padding(.all, 7)
                                .background(
                                    formViewModel.weight == .extreme ? formViewModel.selectedMood?.getColor() : .gray.opacity(0.3)
                                )
                                .foregroundStyle(
                                    formViewModel.weight == .extreme ?
                                    ((formViewModel.selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: formViewModel.weight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    formViewModel.weight = .extreme
                                }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}


struct TitleWindowView: View {
    @Namespace private var namespace
    @ObservedObject var formViewModel: MoodFormViewModel
    
    var body: some View {
        HStack {
            if formViewModel.isDisclosed {
                Text("mood")
                    .matchedGeometryEffect(id: "mood", in: namespace)
                    .padding(.top, 5)
                    .foregroundStyle(.appBlack)
                    .opacity(0.7)
                    .fontWeight(.bold)
                
            } else {
                if let mood = formViewModel.selectedMood {
                    HStack {
                        Text(mood.name)
                            .padding(5)
                            .foregroundStyle(.appBlack)
                            .background(mood.getColor().opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        if formViewModel.selectedEmotions.isEmpty {
                            Text("select an emotion")
                                .foregroundStyle(.appRed)
                                .bold()
                        }
                    }
                    .matchedGeometryEffect(id: "selected", in: namespace)
                    
                } else {
                    Text("select a mood")
                        .matchedGeometryEffect(id: "error", in: namespace)
                        .padding(.top, 5)
                        .foregroundStyle(.appBlack)
                    
                }
            }
        }
    }
}


struct SlidableView<Content: View>: View {
    var isDeleteable: Bool
    @Binding var isDisclosed: Bool
    var content: Content
    var delete: () -> Void
    @State private var offset = 0.0
    @State private var didCall: Bool = false
    
    var body: some View {
        ZStack {
            HStack{
                Spacer()
                
                Image(systemName: "trash")
                    .frame(maxHeight: .infinity)
                    .frame(width: abs(offset))
                    .background(.appRed)
                    .foregroundStyle(.appWhite)
                    .onTapGesture {
                        if offset == -75 {
                            withAnimation(.easeInOut(duration: 0.2)){
                                offset = -1000
                            }
                            delete()
                            didCall = true
                        }
                    }
                    .offset(x: abs(offset))
            }
            content
        }
        .offset(x: offset)
        .gesture(
            
            DragGesture()
                .onChanged{ gesture in
                    if isDeleteable {
                        if isDisclosed {
                            withAnimation (.spring(response: 0.8)){
                                isDisclosed = false
                            }
                        }
                        if gesture.translation.width < 0 {
                            offset = gesture.translation.width
                        } else if gesture.translation.width > 0 && offset >= -75 && offset < 0 {
                            offset += 2
                        }
                    }
                }
                .onEnded { _ in
                    if isDeleteable {
                        if offset < -300 && !didCall {
                            withAnimation(.easeInOut(duration: 0.2)){
                                offset = -1000
                            }
                            delete()
                            didCall = true
                        } else if offset < -55 {
                            withAnimation(.easeInOut(duration: 0.5)){
                                offset = -75
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)){
                                offset = .zero
                            }
                        }
                    }
                }
            
        )
    }
}


struct ContextLogView: View {
    @EnvironmentObject var viewModel: UploadMoodViewModel
    @StateObject var formManager: MoodFormManager = MoodFormManager()
    @Binding var context: UnsecureContext?
    private var copyContext: UnsecureContext {
        if let c = context {
            return c
        } else {
            return UnsecureContext(name: "nil", iconName: "exclamationmark.triangle.fill", colorHex: "#0F0F0")
        }
    }
    
    @State var navBarVisibility: Visibility = .visible
    
    @State var contextEmotionPairs: [ContextLogContainer] = []
    
    private var animation: Animation = .easeInOut(duration: 0.25)
    
    init(context c: Binding<UnsecureContext?>) {
        self._context = c
    }
    
    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.context = nil
        }
    }
    
//    init(context c: UnsecureContext? = nil) {
//        self.context = c
//        
//        if let cont = c {
//            self.copyContext = cont
//        } else {
//            self.copyContext = UnsecureContext(name: "nil", iconName: "warning", colorHex: "#0f0f00")
//        }
//    }
    
    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            
            VStack {
                HStack(spacing:0){
                    Text("how do you feel about \(Text(copyContext.name).bold()) ")
                    Image(systemName: copyContext.iconName)
                        .bold()
                        .padding(0)
                }
                .foregroundStyle(copyContext.color.isLight() ? .black : .white)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
                .background(copyContext.color)
                
                ScrollView{
                    
                    ForEach($formManager.formViewModels) { $form in
                        SlidableView( isDeleteable: formManager.formViewModels.count > 1,
                                      isDisclosed: $form.isDisclosed,
                                      content:
                                        CollapsableView(
                                            isDisclosed: $form.isDisclosed,
                                            thumbnail: ThumbnailView{ TitleWindowView(formViewModel: form) },
                                            expanded: ExpandedView{ MoodFormView(formManager: formManager, formViewModel: form) }
                                        )
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 5)
                        ) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                formManager.deleteFormViewModel(removing: form)
                            }
                        }
                        
                    }
                }
                .frame(minHeight: 200, maxHeight: .infinity)
                
                
                VStack {
                    if formManager.formViewModels.count < Mood.allMoods.count{
                        Button{
                            withAnimation (.spring(response: 0.8)){
                                if formManager.formViewModels.count < Mood.allMoods.count {
                                    for form in formManager.formViewModels {
                                        form.isDisclosed = false
                                    }
                                    formManager.addFormViewModel()
                                }
                            }
                        } label: {
                            HStack{
                                Image(systemName: "plus")
                                    .foregroundStyle(.appGreen)
                                Text("add another mood")
                            }
                            .font(.headline)
                            .frame(minWidth: 200, maxWidth: .infinity)
                            .frame(height: 44)
                            .foregroundStyle(.appBlack)
                            .opacity(formManager.allSubmittable ? 1 : 0.5)
                            .background(formManager.allSubmittable ? .appGreen.opacity(0.2) : .gray.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .disabled(!formManager.allSubmittable)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button{
                            formManager.resetFormViewModels()
                            self.dismiss()
                            
                        } label: {
                            HStack{
                                Image(systemName: "xmark")
                                    .foregroundStyle(.appRed)
                                Text("cancel")
                            }
                            .font(.headline)
                            .foregroundStyle(.appBlack)
                            .frame(width: 150, height: 44)
                            .background(.appRed.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Spacer()
                        
                        Button{
                            //                    print("isSubmittable: \(isSubmittable.description), arry isEmpty: \(!viewModel.formViewModels.isEmpty), weight is selected: \( (viewModel.formViewModels.first?.selectedEmotions.isEmpty) )")
                            if formManager.allSubmittable {
                                viewModel.createContextLogContainersFromFormViewModels(contextID: copyContext.id, moodFormManager: formManager)
                                self.dismiss()
                            }
                            
                        } label: {
                            HStack{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.appPurple)
                                Text("save")
                            }
                            .font(.headline)
                            .foregroundStyle(.appBlack)
                            .frame(width: 150, height: 44)
                            .opacity(formManager.allSubmittable ? 1 : 0.5)
                            .background(formManager.allSubmittable ? .appPurple.opacity(0.15) : .gray.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .disabled(!formManager.allSubmittable)
                    }
                }
                .padding(.horizontal, 35)
                .frame(height: 110)
            }
        }
        .withTabBarVisibilityController()
        .zIndex(100)
        .transition(
            .move(edge: .bottom)
        )
        .toolbarVisibility(navBarVisibility, for: .navigationBar)
        .animation(.easeInOut(duration: 1), value: self.navBarVisibility)
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: 190_000_000)
                navBarVisibility = .hidden
            }
        }
        .onDisappear {
            Task {
                try await Task.sleep(nanoseconds: 190_000_000)
                navBarVisibility = .visible
            }
        }
    }
}

#Preview {
    @Previewable @State var context: UnsecureContext? = UnsecureContext.defaultContexts[4]
    
    ContextLogView(context: $context)
        .environmentObject(UploadMoodViewModel())
}
