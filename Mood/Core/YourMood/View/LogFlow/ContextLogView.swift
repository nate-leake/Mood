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
        MoodTagView(selectedMood: $formViewModel.selectedMood, assignedMoods: $formManager.takenMoods)
        
        VStack{
            
            if formViewModel.selectedMood != nil {
                VStack{
                    Divider()
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    HStack{
                        Text("emotion")
                            .padding(.leading, 10)
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
                            .padding(.leading, 10)
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

struct ContextLogView: View {
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var viewModel: UploadMoodViewModel
    @StateObject var formManager: MoodFormManager = MoodFormManager()
    var context: UnsecureContext
    
    @State var contextEmotionPairs: [ContextEmotionPair] = []
    var isSubmittable: Bool {
        true
    }
    
    var views: [MoodFormView] = []
    
    private var animation: Animation = .easeInOut(duration: 0.25)
    
    init(context: UnsecureContext) {
        self.context = context
    }
    
    var body: some View {
        VStack {
            VStack{
                Text("how do you feel about **\(context.name)**?")
            }
            
            Divider()
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            ScrollView{
                ForEach($formManager.formViewModels, id: \.id) { $view in
                    CollapsableView(openTitle: "mood", closedTitle: view.selectedMood?.name ?? "nothing", isDisclosed: $view.isDisclosed){
                        MoodFormView(formManager: formManager, formViewModel: view)
                    }
                }
                
            }
            .frame(minHeight: 200, maxHeight: .infinity)
            
            
            VStack {
                Button{
                    withAnimation(.easeInOut(duration: 0.25)){
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
                    .opacity(formManager.formViewModels.count < Mood.allMoods.count ? 1 : 0.5)
                    .background(formManager.formViewModels.count < Mood.allMoods.count ? .appGreen.opacity(0.2) : .gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(formManager.formViewModels.count >= Mood.allMoods.count)
                
                Spacer()
                
                HStack {
                    Button{
                        formManager.resetFormViewModels()
                        dismissSheet()
                        
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
                        if isSubmittable {
                            //                            viewModel.createPairsFromFormViewModels(contextID: context.id)
                            dismissSheet()
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
                        .opacity(isSubmittable ? 1 : 0.5)
                        .background(isSubmittable ? .appPurple.opacity(0.15) : .gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(!isSubmittable)
                }
            }
            .padding(.horizontal, 35)
            .frame(height: 110)
        }
    }
}

#Preview {
    ContextLogView(context: UnsecureContext.defaultContexts[0])
        .environmentObject(UploadMoodViewModel())
}
