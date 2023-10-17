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
    @State var selectedMood: Mood?/* = Mood.allMoods[0]*/
    @State var selectedEmotions: [Emotion] = []/* = Mood.allMoods[0].emotions[0]*/
    @State var intensity: Double = 0.0
    
    var min = Weight.none.rawValue
    var max = Weight.extreme.rawValue
    var step = 1.0
    
    init(contexts: [String], isPresented: Binding<Bool>, contextIndex: Int = 0) {
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
                    EmotionTagView(selectedEmotions: $selectedEmotions, mood: selectedMood!)
                }
            }
            
            
            if !selectedEmotions.isEmpty {
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
                Slider(value: $intensity,
                       in: Double(min)...Double(max),
                       step: step,
                       minimumValueLabel: Text("none"),
                       maximumValueLabel: Text("extreme"),
                       label: { })
                .padding(.horizontal, 10)
                
                .tint(selectedMood!.getColor())
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
                        LogMoodView(contexts: contexts, isPresented: $isPresented, contextIndex: contextIndex+1)
                            .environmentObject(viewModel)
                            .onAppear{
                                viewModel.dailyData.addPair(pair: ContextEmotionPair(context: contexts[contextIndex], emotions: selectedEmotions, weight: Weight(rawValue: Int(intensity)) ?? .none))
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
                        .background((!selectedEmotions.isEmpty) ? .appPurple : .appPurple.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(.easeInOut, value: (selectedEmotions.isEmpty))
                    }
                    .disabled(selectedEmotions.isEmpty)
                } else {
                    NavigationLink {
                        MoodLoggedView(isPresented: $isPresented)
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden(true)
                            .onAppear{
                                print("finished")
                                viewModel.dailyData.date = Date()
                                print("DailyData length: \(viewModel.dailyData.pairs.count)")
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
                        .background((!selectedEmotions.isEmpty) ? .appPurple : .appPurple.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(.easeInOut, value: (selectedEmotions.isEmpty))
                    }
                    .disabled(selectedEmotions.isEmpty)
                }
                
                Spacer()
            }
        }
        .onAppear{
            if let pair = viewModel.dailyData.containsPair(withContext: contexts[contextIndex]) {
                
                if let mood = Emotion(name: pair.emotions[0]).getParentMood(){
                    self.selectedMood = mood
                } else {
                    print("cannot find a parent mood for emotion \(pair.emotions[0])")
                }
                
                var previousSelectedEmotions: [Emotion] = []
                for emotion in pair.emotions {
                    previousSelectedEmotions.append(Emotion(name: emotion))
                }
                
                
                self.selectedEmotions = previousSelectedEmotions
                self.intensity = Double(pair.weight.rawValue)
            }
        }
        .padding()
    }
}

#Preview {
    @State var isPresented: Bool = true
    
    return LogMoodView(contexts: ["family","health","identity","finances","politics","weather","work"], isPresented: $isPresented)
        .environmentObject(UploadMoodViewModel())
}
