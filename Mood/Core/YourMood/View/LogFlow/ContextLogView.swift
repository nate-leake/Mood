//
//  ContextLogView.swift
//  Mood
//
//  Created by Nate Leake on 9/19/24.
//

import SwiftUI

struct ContextLogView: View {
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var viewModel: UploadMoodViewModel
    var context: Context
    
    @State var selectedMood: Mood? /*= Mood.allMoods[0]*/
    @State var selectedEmotions: [Emotion] = [] /*= Mood.allMoods[0].emotions*/
    @State var selectedWeight: Weight = .none
    
    private var animation: Animation = .easeInOut(duration: 0.25)
    
    init(context: Context) {
        self.context = context
    }
    
    var body: some View {
        VStack{
            Text("how do you feel about **\(context.name)**?")
        }
        Divider()
            .padding(.top, 20)
            .padding(.bottom, 10)
        
        HStack{
            Text("mood")
                .padding(.leading, 10)
                .opacity(0.7)
                .fontWeight(.bold)
            Spacer()
        }
        
        MoodTagView(selectedMoods: $selectedMood)
        
        VStack{
            
            if selectedMood != nil {
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
                        selectedEmotions: $selectedEmotions,
                        mood: selectedMood ?? Mood.allMoods[0]
                    )
                }
            }
            
            
            if !selectedEmotions.isEmpty {
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
                                    selectedWeight == .none ? selectedMood?
                                        .getColor() : .gray
                                        .opacity(0.3)
                                )
                                .foregroundStyle(
                                    selectedWeight == .none ?
                                    ((selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: selectedWeight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedWeight = .none
                                }
                            
                            Text("slight")
                                .padding(.all, 7)
                                .background(
                                    selectedWeight == .slight ? selectedMood?
                                        .getColor() : .gray
                                        .opacity(0.3)
                                )
                                .foregroundStyle(
                                    selectedWeight == .slight ?
                                    ((selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: selectedWeight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedWeight = .slight
                                }
                            
                            Text("moderate")
                                .padding(.all, 7)
                                .background(
                                    selectedWeight == .moderate ? selectedMood?
                                        .getColor() : .gray
                                        .opacity(0.3)
                                )
                                .foregroundStyle(
                                    selectedWeight == .moderate ?
                                    ((selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: selectedWeight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedWeight = .moderate
                                }
                            
                            Text("extreme")
                                .padding(.all, 7)
                                .background(
                                    selectedWeight == .extreme ? selectedMood?.getColor() : .gray.opacity(0.3)
                                )
                                .foregroundStyle(
                                    selectedWeight == .extreme ?
                                    ((selectedMood?.getColor().isLight())! ? Color.black : Color.white) :
                                        (.appBlack)
                                )
                                .animation(animation, value: selectedWeight)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    selectedWeight = .extreme
                                }
                        }
                        Spacer()
                    }
                }
            }
        }
        
        Spacer()
        
        HStack {
            Spacer()
            Button{
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
                if !selectedEmotions.isEmpty{
                    let contextPair = ContextEmotionPair(context: context.name, emotions: selectedEmotions, weight: selectedWeight)
                    dismissSheet()
                    viewModel.addPair(contextPair)
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
                .opacity(!selectedEmotions.isEmpty ? 1 : 0.5)
                .background(!selectedEmotions.isEmpty ? .appPurple.opacity(0.15) : .gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    ContextLogView(context: Context.allContexts[0])
        .environmentObject(UploadMoodViewModel())
}
