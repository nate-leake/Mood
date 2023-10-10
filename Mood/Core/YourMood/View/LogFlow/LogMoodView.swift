//
//  LogFamilyView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import SwiftUI

struct LogMoodView: View {
    @EnvironmentObject var viewModel: LogDailyMoodViewModel
    var contexts: [String]
    var contextIndex: Int
    @State var selectedMood: Mood?/* = Mood.allMoods[0]*/
    @State var selectedEmotions: [Emotion] = []/* = Mood.allMoods[0].emotions[0]*/
    @State var intensity: Double = 0.0
    
    var min = Weight.none.rawValue
    var max = Weight.extreme.rawValue
    var step = 1.0
    
    init(contexts: [String], contextIndex: Int = 0) {
        self.contexts = contexts
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
                
                Button{
                    print("back")
                } label: {
                    HStack{
                        Image(systemName: "arrow.left")
                        Text("back")
                            
                    }
                    .font(.headline)
                    .foregroundStyle(.appBlack)
                    .frame(width: 150, height: 44)
                    .background(.appBlack.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Spacer()
                
                if contextIndex+1 < contexts.count {
                    NavigationLink{
                        LogMoodView(contexts: contexts, contextIndex: contextIndex+1)
                            .onAppear{
                                print("context: \(contexts[contextIndex])")
                                print("emotions: \(selectedEmotions)")
                                print("weight: \(String(describing: Weight(rawValue: Int(intensity))))")
//                                viewModel.dailyData.pairs.append(ContextMoodPair(context: contexts[contextIndex], moods: <#T##[String]#>, weight: Weight(rawValue: Int(intensity)) ?? .none))
                            }
                    } label: {
                        HStack{
                            Text("next")
                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 150, height: 44)
                        .background((!selectedEmotions.isEmpty) ? .appPurple : .appPurple.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(.easeInOut, value: (selectedEmotions.isEmpty))
                    }
                } else {
                    Button {
                        print("finished")
                        
                    } label: {
                        HStack{
                            Text("finish")
                            Image(systemName: "checkmark")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 150, height: 44)
                        .background((!selectedEmotions.isEmpty) ? .appPurple : .appPurple.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .animation(.easeInOut, value: (selectedEmotions.isEmpty))
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .transition(.opacity)
        
    }
}

#Preview {
    LogMoodView(contexts: ["family","health","identity","finances","politics","weather","work"])
}
