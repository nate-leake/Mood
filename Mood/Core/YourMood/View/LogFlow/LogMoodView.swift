//
//  LogFamilyView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import SwiftUI

struct LogMoodView: View {
    @EnvironmentObject var viewModel: UploadMoodViewModel
    @Binding var isPresented: Bool
    var contexts: [String]
    var contextIndex: Int
    @State var selectedMood: Mood? /*= Mood.allMoods[0]*/
    @State var selectedEmotions: [Emotion] = [] /*= Mood.allMoods[0].emotions*/
    @State var selectedWeight: Weight = .none
    private var animation: Animation = .easeInOut(duration: 0.25)
    
    init(
        contexts: [String],
        isPresented: Binding<Bool>,
        contextIndex: Int = 0
    ) {
        self.contexts = contexts
        self._isPresented = isPresented
        self.contextIndex = contextIndex
    }
    
    func formated(value: CGFloat) -> String {
        return String(format: "%.0f", value)
    }
    
    var body: some View {
        VStack{
            Text("how do you feel about **\(contexts[contextIndex])**?")
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
            
            HStack{
                
                Spacer()
                
                if contextIndex == 0{
                    Button{
                        print("close")
                        isPresented = false
                    } label: {
                        HStack{
                            Image(systemName: "xmark")
                            Text("close")
                            
                        }
                        .font(.headline)
                        .foregroundStyle(.appBlack)
                        .frame(width: 150, height: 44)
                        .background(.appBlack.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                }
                
                if contextIndex+1 < contexts.count {
                    NavigationLink{
                        LogMoodView(
                            contexts: contexts,
                            isPresented: $isPresented,
                            contextIndex: contextIndex+1
                        )
                        .environmentObject(viewModel)
                        .onAppear{
                            viewModel.dailyData
                                .addPair(
                                    pair: ContextEmotionPair(
                                        context: contexts[contextIndex],
                                        emotions: selectedEmotions,
                                        weight: selectedWeight
                                    )
                                )
                        }
                    } label: {
                        HStack{
                            Text("next")
                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(height: 44)
                        .frame(maxWidth: contextIndex == 0 ? 150 : .infinity)
                        .background(
                            (
                                !selectedEmotions.isEmpty
                            ) ? .appPurple : .appPurple
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(
                            .easeInOut,
                            value: (selectedEmotions.isEmpty)
                        )
                    }
                    .disabled(selectedEmotions.isEmpty)
                } else {
                    NavigationLink {
                        MoodLoggedView(isPresented: $isPresented)
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden(true)
                            .onAppear{
                                viewModel.dailyData
                                    .addPair(
                                        pair: ContextEmotionPair(
                                            context: contexts[contextIndex],
                                            emotions: selectedEmotions,
                                            weight: selectedWeight
                                        )
                                    )
                                print("finished")
                                viewModel.dailyData.date = Date()
                                print(
                                    "DailyData length: \(viewModel.dailyData.pairs.count)"
                                )
                            }
                        
                    } label: {
                        HStack{
                            Text("finish")
                            Image(systemName: "checkmark")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(
                            (
                                !selectedEmotions.isEmpty
                            ) ? .appPurple : .appPurple
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(
                            .easeInOut,
                            value: (selectedEmotions.isEmpty)
                        )
                    }
                    .disabled(selectedEmotions.isEmpty)
                }
                
                Spacer()
            }
        }
        .onAppear{
            if let pair = viewModel.dailyData.containsPair(
                withContext: contexts[contextIndex]
            ) {
                
                if let mood = Emotion(name: pair.emotions[0]).getParentMood(){
                    self.selectedMood = mood
                } else {
                    print(
                        "cannot find a parent mood for emotion \(pair.emotions[0])"
                    )
                }
                
                var previousSelectedEmotions: [Emotion] = []
                for emotion in pair.emotions {
                    previousSelectedEmotions.append(Emotion(name: emotion))
                }
                
                
                self.selectedEmotions = previousSelectedEmotions
                self.selectedWeight = pair.weight
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    
    return LogMoodView(
        contexts: [
            "family",
            "health",
            "identity",
            "finances",
            "politics",
            "weather",
            "work"
        ],
        isPresented: $isPresented
    )
    .environmentObject(UploadMoodViewModel())
}
